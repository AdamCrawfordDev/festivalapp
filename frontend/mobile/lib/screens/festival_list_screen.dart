import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../features/festivals/festival_list_controller.dart';
import '../models/festival.dart';

class FestivalListScreen
    extends ConsumerWidget {
  const FestivalListScreen({
    super.key,
  });

  Future<void> _refresh(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await ref
          .read(
            festivalListProvider
                .notifier,
          )
          .forceSync();
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not refresh festivals. '
            'Showing downloaded data.',
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
    final festivalList =
        ref.watch(
      festivalListProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Festivals',
        ),
      ),
      body: festivalList.when(
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
          /*
           * This branch now represents a local provider or
           * database failure. Ordinary network failures are
           * stored as syncError while cached data remains
           * available.
           */
          return _FestivalError(
            message:
                error.toString(),
            onRetry: () {
              ref.invalidate(
                festivalListProvider,
              );
            },
          );
        },
        data: (festivalState) {
          final festivals =
              festivalState
                  .festivals;

          if (festivals.isEmpty) {
            return RefreshIndicator(
              onRefresh: () {
                return _refresh(
                  context,
                  ref,
                );
              },
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height:
                        MediaQuery.sizeOf(
                              context,
                            ).height *
                            0.7,
                    child:
                        _EmptyFestivalList(
                      isSyncing:
                          festivalState
                              .isSyncing,
                      hasSyncError:
                          festivalState
                                  .syncError !=
                              null,
                    ),
                  ),
                ],
              ),
            );
          }

          final showOfflineNotice =
              festivalState
                      .syncError !=
                  null;

          final additionalItems =
              showOfflineNotice
                  ? 1
                  : 0;

          return RefreshIndicator(
            onRefresh: () {
              return _refresh(
                context,
                ref,
              );
            },
            child:
                ListView.separated(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.all(
                16,
              ),
              itemCount:
                  festivals.length +
                  additionalItems,
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
                if (
                  showOfflineNotice &&
                  index == 0
                ) {
                  return const
                      _OfflineNotice();
                }

                final festivalIndex =
                    showOfflineNotice
                        ? index - 1
                        : index;

                final festival =
                    festivals[
                      festivalIndex
                    ];

                return FestivalCard(
                  festival:
                      festival,
                  onTap: () {
                    context.push(
                      '/festivals/'
                      '${festival.id}',
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FestivalCard
    extends StatelessWidget {
  const FestivalCard({
    required this.festival,
    required this.onTap,
    super.key,
  });

  final Festival festival;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final dates =
        '${DateFormat('d MMM').format(
          festival.startDate,
        )} – '
        '${DateFormat('d MMM yyyy').format(
          festival.endDate,
        )}';

    return Card(
      clipBehavior:
          Clip.antiAlias,
      child: InkWell(
        onTap:
            onTap,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              width:
                  double.infinity,
              child:
                  festival.image !=
                          null
                      ? CachedNetworkImage(
                          imageUrl:
                              festival
                                  .image!,
                          fit:
                              BoxFit.cover,
                          errorWidget:
                              (
                                context,
                                url,
                                error,
                              ) {
                            return const
                                _ImageFallback();
                          },
                        )
                      : const
                          _ImageFallback(),
            ),
            Padding(
              padding:
                  const EdgeInsets.all(
                16,
              ),
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
                            .titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    dates,
                  ),
                  if (
                    festival
                        .description
                        .isNotEmpty
                  ) ...[
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      festival
                          .description,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineNotice
    extends StatelessWidget {
  const _OfflineNotice();

  @override
  Widget build(
    BuildContext context,
  ) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return Material(
      color:
          colors.secondaryContainer,
      borderRadius:
          BorderRadius.circular(
        12,
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        child: Row(
          children: [
            Icon(
              Icons
                  .cloud_off_outlined,
              size: 20,
              color:
                  colors
                      .onSecondaryContainer,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'You’re offline. Showing '
                'cached festival data.',
                style: TextStyle(
                  color:
                      colors
                          .onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFestivalList
    extends StatelessWidget {
  const _EmptyFestivalList({
    required this.isSyncing,
    required this.hasSyncError,
  });

  final bool isSyncing;
  final bool hasSyncError;

  @override
  Widget build(
    BuildContext context,
  ) {
    if (isSyncing) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    final title =
        hasSyncError
            ? 'No cached festivals'
            : 'No festivals available';

    final message =
        hasSyncError
            ? 'Connect to the internet '
                'and pull down to load '
                'festivals.'
            : 'Pull down to refresh.';

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
            Icon(
              hasSyncError
                  ? Icons
                      .cloud_off_outlined
                  : Icons
                      .festival_outlined,
              size: 52,
              color:
                  Theme.of(context)
                      .colorScheme
                      .primary,
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              title,
              textAlign:
                  TextAlign.center,
              style:
                  Theme.of(context)
                      .textTheme
                      .titleMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageFallback
    extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(
    BuildContext context,
  ) {
    return ColoredBox(
      color:
          Theme.of(context)
              .colorScheme
              .primaryContainer,
      child: Center(
        child: Icon(
          Icons.music_note,
          size: 54,
          color:
              Theme.of(context)
                  .colorScheme
                  .primary,
        ),
      ),
    );
  }
}

class _FestivalError
    extends StatelessWidget {
  const _FestivalError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(
    BuildContext context,
  ) {
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
              Icons
                  .error_outline,
              size: 48,
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Could not load '
              'local festival data',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
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
              onPressed:
                  onRetry,
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