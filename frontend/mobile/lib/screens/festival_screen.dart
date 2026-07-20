import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../features/festivals/festival_detail_controller.dart';
import '../features/festivals/festival_sets_controller.dart';
import '../features/festivals/offline_festival_controller.dart';
import '../models/festival.dart';
import '../models/festival_set.dart';
import '../utils/schedule_utils.dart';
import '../widgets/festival_timeline.dart';

enum FestivalScheduleFilter {
  all,
  liked,
}

enum FestivalScheduleView {
  time,
  stage,
  timeline,
}

class FestivalScreen extends ConsumerStatefulWidget {
  const FestivalScreen({
    required this.festivalId,
    this.scrollToSchedule = false,
    super.key,
  });

  final int festivalId;
  final bool scrollToSchedule;

  @override
  ConsumerState<FestivalScreen> createState() {
    return _FestivalScreenState();
  }
}

class _FestivalScreenState
    extends ConsumerState<FestivalScreen> {
  final ScrollController _scrollController =
      ScrollController();

  final GlobalKey _scheduleKey =
      GlobalKey();

  final TextEditingController _searchController =
      TextEditingController();

  FestivalScheduleFilter _filter =
      FestivalScheduleFilter.all;

  FestivalScheduleView _view =
      FestivalScheduleView.time;

  DateTime? _selectedDay;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    if (widget.scrollToSchedule) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _scrollToSchedule();
        },
      );
    }
  }

  @override
  void didUpdateWidget(
    covariant FestivalScreen oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (
      widget.scrollToSchedule &&
      !oldWidget.scrollToSchedule
    ) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _scrollToSchedule();
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  Future<void> _scrollToSchedule() async {
    for (
      var attempt = 0;
      attempt < 20;
      attempt++
    ) {
      if (!mounted) {
        return;
      }

      final scheduleContext =
          _scheduleKey.currentContext;

      if (scheduleContext != null) {
        await Scrollable.ensureVisible(
          scheduleContext,
          duration: Duration.zero,
          alignment: 0,
        );

        return;
      }

      await Future<void>.delayed(
        const Duration(
          milliseconds: 50,
        ),
      );
    }
  }

  Future<void> _refresh() async {
    await ref
        .read(
          offlineFestivalProvider(
            widget.festivalId,
          ).notifier,
        )
        .forceSync();
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
      _selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final festival = ref.watch(
      festivalDetailProvider(
        widget.festivalId,
      ),
    );

    final sets = ref.watch(
      festivalSetsProvider(
        widget.festivalId,
      ),
    );

    return Scaffold(
      body: festival.when(
        loading: () {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        },
        error: (
          error,
          stackTrace,
        ) {
          return _PageError(
            message: error.toString(),
            onRetry: _refresh,
          );
        },
        data: (festivalData) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              controller:
                  _scrollController,
              physics:
                  const AlwaysScrollableScrollPhysics(),
              slivers: [
                _FestivalHeader(
                  festival:
                      festivalData,
                ),
                ...sets.when(
                  loading: () {
                    return [
                      const SliverFillRemaining(
                        hasScrollBody:
                            false,
                        child: Center(
                          child:
                              CircularProgressIndicator(),
                        ),
                      ),
                    ];
                  },
                  error: (
                    error,
                    stackTrace,
                  ) {
                    return [
                      SliverFillRemaining(
                        hasScrollBody:
                            false,
                        child: _PageError(
                          message:
                              error.toString(),
                          onRetry: () {
                            ref
                                .read(
                                  festivalSetsProvider(
                                    widget
                                        .festivalId,
                                  ).notifier,
                                )
                                .refresh();
                          },
                        ),
                      ),
                    ];
                  },
                  data: (items) {
                    return _buildScheduleSlivers(
                      context,
                      items,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildScheduleSlivers(
    BuildContext context,
    List<FestivalSet> allSets,
  ) {
    final likedCount =
        allSets.where(
      (festivalSet) {
        return festivalSet.isLiked;
      },
    ).length;

    final filteredBySchedule =
        _filter ==
                FestivalScheduleFilter
                    .liked
            ? allSets.where(
                (festivalSet) {
                  return festivalSet
                      .isLiked;
                },
              ).toList()
            : List<FestivalSet>.from(
                allSets,
              );

    final query =
        _searchQuery
            .trim()
            .toLowerCase();

    final searchedSets =
        filteredBySchedule.where(
      (festivalSet) {
        if (query.isEmpty) {
          return true;
        }

        return festivalSet.artistName
                .toLowerCase()
                .contains(query) ||
            festivalSet.stageName
                .toLowerCase()
                .contains(query);
      },
    ).toList();

    final groupedSets =
        groupSetsByFestivalDay(
      searchedSets,
    );

    final availableDays =
        groupedSets.keys.toList()
          ..sort();

    DateTime? selectedDay =
        _selectedDay;

    if (
      selectedDay == null ||
      !availableDays.contains(
        selectedDay,
      )
    ) {
      selectedDay =
          availableDays.isNotEmpty
              ? availableDays.first
              : null;
    }

    final displayedSets =
        selectedDay == null
            ? <FestivalSet>[]
            : groupedSets[
                  selectedDay
                ] ??
                [];

    final stageGroups =
        _groupSetsByStage(
      displayedSets,
    );

    return [
      SliverToBoxAdapter(
        child: KeyedSubtree(
          key: _scheduleKey,
          child: Padding(
            padding:
                const EdgeInsets
                    .fromLTRB(
              16,
              22,
              16,
              14,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Schedule',
                        style:
                            Theme.of(
                          context,
                        )
                                .textTheme
                                .headlineSmall,
                      ),
                    ),
                    Text(
                      '${searchedSets.length} sets',
                      style:
                          Theme.of(
                        context,
                      )
                              .textTheme
                              .bodySmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                SegmentedButton<
                  FestivalScheduleFilter
                >(
                  segments: [
                    const ButtonSegment(
                      value:
                          FestivalScheduleFilter
                              .all,
                      icon: Icon(
                        Icons
                            .schedule_outlined,
                      ),
                      label: Text(
                        'All Sets',
                      ),
                    ),
                    ButtonSegment(
                      value:
                          FestivalScheduleFilter
                              .liked,
                      icon: const Icon(
                        Icons
                            .favorite_outline,
                      ),
                      label: Text(
                        'My Schedule '
                        '($likedCount)',
                      ),
                    ),
                  ],
                  selected: {
                    _filter,
                  },
                  showSelectedIcon:
                      false,
                  onSelectionChanged:
                      (selected) {
                    setState(() {
                      _filter =
                          selected.first;

                      _selectedDay =
                          null;
                    });
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                TextField(
                  controller:
                      _searchController,
                  textInputAction:
                      TextInputAction
                          .search,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Search artists or stages',
                    prefixIcon:
                        const Icon(
                      Icons.search,
                    ),
                    suffixIcon:
                        _searchQuery
                                .isEmpty
                            ? null
                            : IconButton(
                                onPressed:
                                    _clearSearch,
                                tooltip:
                                    'Clear search',
                                icon:
                                    const Icon(
                                  Icons.close,
                                ),
                              ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery =
                          value;

                      _selectedDay =
                          null;
                    });
                  },
                ),
                if (
                  availableDays.isNotEmpty
                ) ...[
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 42,
                    child:
                        ListView.separated(
                      scrollDirection:
                          Axis.horizontal,
                      itemCount:
                          availableDays
                              .length,
                      separatorBuilder:
                          (
                            context,
                            index,
                          ) {
                        return const SizedBox(
                          width: 8,
                        );
                      },
                      itemBuilder:
                          (
                            context,
                            index,
                          ) {
                        final day =
                            availableDays[
                              index
                            ];

                        final isSelected =
                            day ==
                            selectedDay;

                        return ChoiceChip(
                          selected:
                              isSelected,
                          onSelected:
                              (_) {
                            setState(() {
                              _selectedDay =
                                  day;
                            });
                          },
                          label: Text(
                            DateFormat(
                              'EEE d MMM',
                            ).format(day),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(
                  height: 14,
                ),
                Text(
                  'View',
                  style:
                      Theme.of(
                    context,
                  )
                          .textTheme
                          .titleSmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                SegmentedButton<
                  FestivalScheduleView
                >(
                  segments: const [
                    ButtonSegment(
                      value:
                          FestivalScheduleView
                              .time,
                      icon: Icon(
                        Icons
                            .view_agenda_outlined,
                      ),
                      label: Text(
                        'Time',
                      ),
                    ),
                    ButtonSegment(
                      value:
                          FestivalScheduleView
                              .stage,
                      icon: Icon(
                        Icons
                            .festival_outlined,
                      ),
                      label: Text(
                        'Stage',
                      ),
                    ),
                    ButtonSegment(
                      value:
                          FestivalScheduleView
                              .timeline,
                      icon: Icon(
                        Icons
                            .timeline_outlined,
                      ),
                      label: Text(
                        'Timeline',
                      ),
                    ),
                  ],
                  selected: {
                    _view,
                  },
                  showSelectedIcon:
                      false,
                  onSelectionChanged:
                      (selected) {
                    setState(() {
                      _view =
                          selected.first;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      if (displayedSets.isEmpty)
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptySchedule(
            isLikedSchedule:
                _filter ==
                FestivalScheduleFilter
                    .liked,
            hasSearch:
                query.isNotEmpty,
            onShowAll: () {
              setState(() {
                _filter =
                    FestivalScheduleFilter
                        .all;

                _selectedDay = null;
              });
            },
            onClearSearch:
                _clearSearch,
          ),
        )
      else if (
        _view ==
        FestivalScheduleView.time
      )
        SliverPadding(
          padding:
              const EdgeInsets
                  .fromLTRB(
            16,
            0,
            16,
            32,
          ),
          sliver:
              SliverList.separated(
            itemCount:
                displayedSets.length,
            separatorBuilder:
                (
                  context,
                  index,
                ) {
              return const SizedBox(
                height: 10,
              );
            },
            itemBuilder:
                (
                  context,
                  index,
                ) {
              return FestivalSetCard(
                festivalSet:
                    displayedSets[
                      index
                    ],
                festivalId:
                    widget.festivalId,
              );
            },
          ),
        )
      else if (
        _view ==
        FestivalScheduleView.stage
      )
        SliverPadding(
          padding:
              const EdgeInsets
                  .fromLTRB(
            16,
            0,
            16,
            32,
          ),
          sliver:
              SliverList.separated(
            itemCount:
                stageGroups.length,
            separatorBuilder:
                (
                  context,
                  index,
                ) {
              return const SizedBox(
                height: 14,
              );
            },
            itemBuilder:
                (
                  context,
                  index,
                ) {
              final stageEntry =
                  stageGroups.entries
                      .elementAt(index);

              return StageScheduleGroup(
                stageName:
                    stageEntry.key,
                sets:
                    stageEntry.value,
                festivalId:
                    widget.festivalId,
              );
            },
          ),
        )
      else
        SliverPadding(
          padding:
              const EdgeInsets
                  .fromLTRB(
            16,
            0,
            16,
            32,
          ),
          sliver:
              SliverToBoxAdapter(
            child: FestivalTimeline(
              sets: displayedSets,
              festivalId:
                  widget.festivalId,
            ),
          ),
        ),
    ];
  }

  Map<String, List<FestivalSet>>
      _groupSetsByStage(
    List<FestivalSet> sets,
  ) {
    final grouped =
        <String, List<FestivalSet>>{};

    for (final festivalSet in sets) {
      grouped
          .putIfAbsent(
            festivalSet.stageName,
            () => [],
          )
          .add(festivalSet);
    }

    final stageNames =
        grouped.keys.toList()
          ..sort(
            (
              first,
              second,
            ) {
              return first
                  .toLowerCase()
                  .compareTo(
                    second
                        .toLowerCase(),
                  );
            },
          );

    return {
      for (
        final stageName
            in stageNames
      )
        stageName:
            grouped[stageName]!
              ..sort(
                (
                  first,
                  second,
                ) {
                  return first.startTime
                      .compareTo(
                    second.startTime,
                  );
                },
              ),
    };
  }
}

class StageScheduleGroup
    extends StatelessWidget {
  const StageScheduleGroup({
    required this.stageName,
    required this.sets,
    required this.festivalId,
    super.key,
  });

  final String stageName;
  final List<FestivalSet> sets;
  final int festivalId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          14,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration:
                      BoxDecoration(
                    color:
                        Theme.of(
                      context,
                    )
                            .colorScheme
                            .primaryContainer,
                    borderRadius:
                        BorderRadius
                            .circular(
                      10,
                    ),
                  ),
                  child: Icon(
                    Icons
                        .festival_outlined,
                    color:
                        Theme.of(
                      context,
                    )
                            .colorScheme
                            .primary,
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                Expanded(
                  child: Text(
                    stageName,
                    style:
                        Theme.of(
                      context,
                    )
                            .textTheme
                            .titleMedium,
                  ),
                ),
                Text(
                  '${sets.length}',
                  style:
                      Theme.of(
                    context,
                  )
                          .textTheme
                          .bodySmall,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ...List.generate(
              sets.length,
              (index) {
                final festivalSet =
                    sets[index];

                return Padding(
                  padding:
                      EdgeInsets.only(
                    bottom:
                        index ==
                                sets.length -
                                    1
                            ? 0
                            : 10,
                  ),
                  child:
                      FestivalSetCard(
                    festivalSet:
                        festivalSet,
                    festivalId:
                        festivalId,
                    nested: true,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FestivalSetCard
    extends ConsumerWidget {
  const FestivalSetCard({
    required this.festivalSet,
    required this.festivalId,
    this.nested = false,
    super.key,
  });

  final FestivalSet festivalSet;
  final int festivalId;
  final bool nested;

  Future<void> _toggleLike(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = ref.read(
      festivalSetsProvider(
        festivalId,
      ).notifier,
    );

    if (
      controller.isSetPending(
        festivalSet.id,
      )
    ) {
      return;
    }

    try {
      await controller.toggleLike(
        festivalSet.id,
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not update your '
            'schedule.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final localStart =
        festivalSet.startTime
            .toLocal();

    final localEnd =
        festivalSet.endTime
            .toLocal();

    final timeText =
        '${DateFormat('HH:mm').format(
          localStart,
        )} – '
        '${DateFormat('HH:mm').format(
          localEnd,
        )}';

    final content = Padding(
      padding:
          const EdgeInsets.all(
        12,
      ),
      child: Row(
        children: [
          _SetImage(
            imageUrl:
                festivalSet
                    .displayImage,
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  festivalSet
                      .artistName,
                  maxLines: 2,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      Theme.of(
                    context,
                  )
                          .textTheme
                          .titleMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  timeText,
                  style:
                      Theme.of(
                    context,
                  )
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  festivalSet
                      .stageName,
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      Theme.of(
                    context,
                  )
                          .textTheme
                          .bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _toggleLike(
                context,
                ref,
              );
            },
            tooltip:
                festivalSet.isLiked
                    ? 'Remove from '
                        'schedule'
                    : 'Add to '
                        'schedule',
            icon:
                AnimatedSwitcher(
              duration:
                  const Duration(
                milliseconds: 180,
              ),
              transitionBuilder:
                  (
                    child,
                    animation,
                  ) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                festivalSet.isLiked
                    ? Icons.favorite
                    : Icons
                        .favorite_border,
                key: ValueKey(
                  festivalSet
                      .isLiked,
                ),
                color:
                    festivalSet
                            .isLiked
                        ? Theme.of(
                            context,
                          )
                              .colorScheme
                              .primary
                        : null,
              ),
            ),
          ),
        ],
      ),
    );

    if (nested) {
      return DecoratedBox(
        decoration:
            BoxDecoration(
          color:
              Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(
                    alpha: 0.35,
                  ),
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          onTap: () {
            // Later: open set details.
          },
          child: content,
        ),
      );
    }

    return Card(
      child: InkWell(
        onTap: () {
          // Later: open set details.
        },
        child: content,
      ),
    );
  }
}

class _EmptySchedule
    extends StatelessWidget {
  const _EmptySchedule({
    required this.isLikedSchedule,
    required this.hasSearch,
    required this.onShowAll,
    required this.onClearSearch,
  });

  final bool isLikedSchedule;
  final bool hasSearch;
  final VoidCallback onShowAll;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    if (hasSearch) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(
            32,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 58,
                color:
                    Theme.of(context)
                        .colorScheme
                        .primary,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'No matching sets',
                style:
                    Theme.of(
                  context,
                )
                        .textTheme
                        .titleLarge,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Try another artist or '
                'stage name.',
                textAlign:
                    TextAlign.center,
                style:
                    Theme.of(
                  context,
                )
                        .textTheme
                        .bodyMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton.icon(
                onPressed:
                    onClearSearch,
                icon:
                    const Icon(
                  Icons.close,
                ),
                label:
                    const Text(
                  'Clear search',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!isLikedSchedule) {
      return const Center(
        child: Text(
          'No sets have been '
          'published yet.',
        ),
      );
    }

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          32,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 58,
              color:
                  Theme.of(context)
                      .colorScheme
                      .primary,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Build your schedule',
              textAlign:
                  TextAlign.center,
              style:
                  Theme.of(context)
                      .textTheme
                      .titleLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Like the sets you want '
              'to see and they will '
              'appear here.',
              textAlign:
                  TextAlign.center,
              style:
                  Theme.of(context)
                      .textTheme
                      .bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
              onPressed: onShowAll,
              icon: const Icon(
                Icons.schedule,
              ),
              label: const Text(
                'Browse all sets',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FestivalHeader
    extends StatelessWidget {
  const _FestivalHeader({
    required this.festival,
  });

  final Festival festival;

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${DateFormat('d MMM').format(
          festival.startDate,
        )} – '
        '${DateFormat('d MMM yyyy').format(
          festival.endDate,
        )}';

    return SliverAppBar(
      expandedHeight: 330,
      pinned: true,
      stretch: true,
      flexibleSpace:
          FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (
              festival.image != null
            )
              CachedNetworkImage(
                imageUrl:
                    festival.image!,
                fit: BoxFit.cover,
                errorWidget:
                    (
                      context,
                      url,
                      error,
                    ) {
                  return const _FestivalImageFallback();
                },
              )
            else
              const _FestivalImageFallback(),
            const DecoratedBox(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment
                          .topCenter,
                  end:
                      Alignment
                          .bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(
                      0xD9000000,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    festival.name,
                    style:
                        Theme.of(
                      context,
                    )
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color:
                                  Colors
                                      .white,
                            ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    dateText,
                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      _OrganiserAvatar(
                        imageUrl:
                            festival
                                .organiserProfilePicture,
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      Expanded(
                        child: Text(
                          festival
                              .organiserName,
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FestivalImageFallback
    extends StatelessWidget {
  const _FestivalImageFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color:
          Theme.of(context)
              .colorScheme
              .primaryContainer,
      child: Center(
        child: Icon(
          Icons.festival_rounded,
          size: 90,
          color:
              Theme.of(context)
                  .colorScheme
                  .primary,
        ),
      ),
    );
  }
}

class _OrganiserAvatar
    extends StatelessWidget {
  const _OrganiserAvatar({
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return const CircleAvatar(
        radius: 17,
        child: Icon(
          Icons.person,
          size: 18,
        ),
      );
    }

    return CircleAvatar(
      radius: 17,
      backgroundImage:
          CachedNetworkImageProvider(
        imageUrl!,
      ),
    );
  }
}

class _SetImage
    extends StatelessWidget {
  const _SetImage({
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback =
        ColoredBox(
      color:
          Theme.of(context)
              .colorScheme
              .primaryContainer,
      child: Center(
        child: Icon(
          Icons.music_note,
          color:
              Theme.of(context)
                  .colorScheme
                  .primary,
        ),
      ),
    );

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(
        12,
      ),
      child: SizedBox(
        width: 68,
        height: 68,
        child:
            imageUrl == null
                ? fallback
                : CachedNetworkImage(
                    imageUrl:
                        imageUrl!,
                    fit:
                        BoxFit.cover,
                    errorWidget:
                        (
                          context,
                          url,
                          error,
                        ) {
                      return fallback;
                    },
                  ),
      ),
    );
  }
}

class _PageError
    extends StatelessWidget {
  const _PageError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 46,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            FilledButton(
              onPressed: onRetry,
              child:
                  const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}