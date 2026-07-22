import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../features/festivals/festival_sets_controller.dart';
import '../models/festival_set.dart';
import '../utils/schedule_utils.dart';

class FestivalTimeline extends ConsumerStatefulWidget {
  const FestivalTimeline({
    required this.sets,
    required this.festivalId,
    super.key,
  });

  final List<FestivalSet> sets;
  final int festivalId;

  @override
  ConsumerState<FestivalTimeline> createState() {
    return _FestivalTimelineState();
  }
}

class _FestivalTimelineState
    extends ConsumerState<FestivalTimeline> {
  static const double _stageColumnWidth = 118;
  static const double _headerHeight = 48;
  static const double _rowHeight = 84;

  static const double _baseHourWidth = 110;
  static const double _minimumSetWidth = 72;

  static const double _preferredMinimumScale = 0.65;
  static const double _maximumScale = 3.5;
  static const double _maximumViewportHeight = 520;

  final TransformationController _transformationController =
      TransformationController();

  double _scale = 1;

  @override
  void initState() {
    super.initState();

    _transformationController.addListener(
      _handleTransformationChanged,
    );
  }

  @override
  void didUpdateWidget(
    covariant FestivalTimeline oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    /*
     * Reset when the selected day, search results, or
     * liked-only filter produces a different set list.
     */
    if (!_haveSameSetIds(
      oldWidget.sets,
      widget.sets,
    )) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (mounted) {
            _resetView();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _transformationController.removeListener(
      _handleTransformationChanged,
    );

    _transformationController.dispose();

    super.dispose();
  }

  bool _haveSameSetIds(
    List<FestivalSet> first,
    List<FestivalSet> second,
  ) {
    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      if (first[index].id != second[index].id) {
        return false;
      }
    }

    return true;
  }

  void _handleTransformationChanged() {
    final nextScale =
        _transformationController.value.getMaxScaleOnAxis();

    if ((nextScale - _scale).abs() < 0.01) {
      return;
    }

    setState(() {
      _scale = nextScale;
    });
  }

  void _resetView() {
    _transformationController.value =
        Matrix4.identity();
  }

  Future<void> _toggleLike(
    FestivalSet festivalSet,
  ) async {
    final controller = ref.read(
      festivalSetsProvider(
        widget.festivalId,
      ).notifier,
    );

    if (controller.isSetPending(
      festivalSet.id,
    )) {
      return;
    }

    try {
      await controller.toggleLike(
        festivalSet.id,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not update your schedule.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sets.isEmpty) {
      return const Center(
        child: Text(
          'No sets available for this day.',
        ),
      );
    }

    final timeline = _buildTimelineData(
      widget.sets,
    );

    final totalHeight =
        _headerHeight +
        timeline.stageRows.length *
            _rowHeight;

    final totalWidth =
        _stageColumnWidth +
        timeline.timelineWidth;

    final viewportHeight = math.min(
      totalHeight,
      _maximumViewportHeight,
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(
            bottom: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Pinch to zoom and drag to move',
                  style:
                      Theme.of(context)
                          .textTheme
                          .bodySmall,
                ),
              ),
              Text(
                '${(_scale * 100).round()}%',
                style:
                    Theme.of(context)
                        .textTheme
                        .labelMedium,
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: _resetView,
                tooltip:
                    'Reset timeline',
                icon: const Icon(
                  Icons
                      .fit_screen_outlined,
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:
                  Theme.of(context)
                      .colorScheme
                      .surface,
              border: Border.all(
                color:
                    Theme.of(context)
                        .colorScheme
                        .outline,
              ),
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: SizedBox(
              height: viewportHeight,
              child: LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  /*
                   * The minimum scale is high enough that
                   * the transformed content cannot become
                   * smaller than the visible viewport.
                   */
                  final widthFitScale =
                      constraints.maxWidth /
                      totalWidth;

                  final heightFitScale =
                      constraints.maxHeight /
                      totalHeight;

                  final double fittedMinimumScale =
                      math.max<double>(
                    _preferredMinimumScale,
                    math.max<double>(
                      widthFitScale,
                      heightFitScale,
                    ),
                  );

                  /*
                   * Never make the minimum larger than 1.
                   * At identity scale the whole timeline
                   * begins aligned to the top-left.
                   */
                  final double minimumScale =
                      math.min<double>(
                    fittedMinimumScale,
                    1.0,
                  );

                  return InteractiveViewer(
                    transformationController:
                        _transformationController,
                    minScale:
                        minimumScale,
                    maxScale:
                        _maximumScale,
                    constrained: false,
                    boundaryMargin:
                        EdgeInsets.zero,
                    alignment:
                        Alignment.topLeft,
                    panEnabled: true,
                    scaleEnabled: true,
                    panAxis:
                        PanAxis.free,
                    clipBehavior:
                        Clip.hardEdge,
                    child: SizedBox(
                      width: totalWidth,
                      height: totalHeight,
                      child: Stack(
                        clipBehavior:
                            Clip.hardEdge,
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            width:
                                totalWidth,
                            height:
                                totalHeight,
                            child:
                                _TimelineGrid(
                              timeline:
                                  timeline,
                              stageColumnWidth:
                                  _stageColumnWidth,
                              headerHeight:
                                  _headerHeight,
                              rowHeight:
                                  _rowHeight,
                              hourWidth:
                                  _baseHourWidth,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            width:
                                _stageColumnWidth,
                            height:
                                totalHeight,
                            child:
                                _StageLabels(
                              stageRows:
                                  timeline
                                      .stageRows,
                              headerHeight:
                                  _headerHeight,
                              rowHeight:
                                  _rowHeight,
                            ),
                          ),
                          Positioned(
                            left:
                                _stageColumnWidth,
                            top: 0,
                            width:
                                timeline
                                    .timelineWidth,
                            height:
                                _headerHeight,
                            child:
                                _TimelineHeader(
                              hourMarkers:
                                  timeline
                                      .hourMarkers,
                              hourWidth:
                                  _baseHourWidth,
                            ),
                          ),
                          ...timeline
                              .stageRows
                              .asMap()
                              .entries
                              .expand(
                            (
                              stageEntry,
                            ) {
                              final rowIndex =
                                  stageEntry
                                      .key;

                              final stageRow =
                                  stageEntry
                                      .value;

                              return stageRow
                                  .sets
                                  .map(
                                (
                                  positionedSet,
                                ) {
                                  return Positioned(
                                    left:
                                        _stageColumnWidth +
                                        positionedSet
                                            .left,
                                    top:
                                        _headerHeight +
                                        rowIndex *
                                            _rowHeight +
                                        7,
                                    width:
                                        positionedSet
                                            .width,
                                    height:
                                        _rowHeight -
                                        14,
                                    child:
                                        _TimelineSetCard(
                                      positionedSet:
                                          positionedSet,
                                      onLikePressed:
                                          () {
                                        _toggleLike(
                                          positionedSet
                                              .set,
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _TimelineData _buildTimelineData(
    List<FestivalSet> sets,
  ) {
    final orderedSets =
        List<FestivalSet>.from(
      sets,
    )
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
          );

    final earliestStart =
        orderedSets
            .map(
              (set) => toFestivalTime(
                set.startTime,
              ),
            )
            .reduce(
              (
                first,
                second,
              ) {
                return first.isBefore(
                  second,
                )
                    ? first
                    : second;
              },
            );

    final latestEnd =
        orderedSets
            .map(
              (set) => toFestivalTime(
                set.endTime,
              ),
            )
            .reduce(
              (
                first,
                second,
              ) {
                return first.isAfter(
                  second,
                )
                    ? first
                    : second;
              },
            );

    final timelineStart =
        DateTime(
      earliestStart.year,
      earliestStart.month,
      earliestStart.day,
      earliestStart.hour,
    );

    var timelineEnd =
        DateTime(
      latestEnd.year,
      latestEnd.month,
      latestEnd.day,
      latestEnd.hour,
    );

    if (
      latestEnd.minute != 0 ||
      latestEnd.second != 0 ||
      latestEnd.millisecond != 0
    ) {
      timelineEnd =
          timelineEnd.add(
        const Duration(
          hours: 1,
        ),
      );
    }

    /*
     * Ensure at least one complete hour exists, even
     * when all supplied data is unusually compressed.
     */
    if (!timelineEnd.isAfter(
      timelineStart,
    )) {
      timelineEnd =
          timelineStart.add(
        const Duration(
          hours: 1,
        ),
      );
    }

    final totalMinutes =
        timelineEnd
            .difference(
              timelineStart,
            )
            .inMinutes;

    final timelineWidth =
        totalMinutes /
        60 *
        _baseHourWidth;

    final stageMap =
        <String,
            List<
                _PositionedFestivalSet>>{};

    for (
      final festivalSet
          in orderedSets
    ) {
      final localStart =
          toFestivalTime(
        festivalSet.startTime,
      );

      final localEnd =
          toFestivalTime(
        festivalSet.endTime,
      );

      final minutesFromStart =
          localStart
              .difference(
                timelineStart,
              )
              .inMinutes;

      final durationMinutes =
          localEnd
              .difference(
                localStart,
              )
              .inMinutes;

      final left =
          minutesFromStart /
          60 *
          _baseHourWidth;

      final calculatedWidth =
          durationMinutes /
          60 *
          _baseHourWidth;

      final positionedSet =
          _PositionedFestivalSet(
        set: festivalSet,
        left: left + 2,
        width: math.max(
          calculatedWidth - 4,
          _minimumSetWidth,
        ),
      );

      stageMap
          .putIfAbsent(
            festivalSet
                .stageName,
            () => [],
          )
          .add(
            positionedSet,
          );
    }

    final stageNames =
        stageMap.keys.toList()
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

    final stageRows =
        stageNames.map(
      (stageName) {
        final positionedSets =
            stageMap[
              stageName
            ]!;

        positionedSets.sort(
          (
            first,
            second,
          ) {
            return first
                .set
                .startTime
                .compareTo(
                  second
                      .set
                      .startTime,
                );
          },
        );

        return _TimelineStageRow(
          stageName:
              stageName,
          sets:
              positionedSets,
        );
      },
    ).toList();

    final hourMarkers =
        <DateTime>[];

    var marker =
        timelineStart;

    while (
      marker.isBefore(
        timelineEnd,
      )
    ) {
      hourMarkers.add(
        marker,
      );

      marker = marker.add(
        const Duration(
          hours: 1,
        ),
      );
    }

    return _TimelineData(
      timelineStart:
          timelineStart,
      timelineEnd:
          timelineEnd,
      timelineWidth:
          timelineWidth,
      stageRows:
          stageRows,
      hourMarkers:
          hourMarkers,
    );
  }
}

class _TimelineGrid
    extends StatelessWidget {
  const _TimelineGrid({
    required this.timeline,
    required this.stageColumnWidth,
    required this.headerHeight,
    required this.rowHeight,
    required this.hourWidth,
  });

  final _TimelineData timeline;
  final double stageColumnWidth;
  final double headerHeight;
  final double rowHeight;
  final double hourWidth;

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme =
        Theme.of(context)
            .colorScheme;

    return CustomPaint(
      painter:
          _TimelineGridPainter(
        stageColumnWidth:
            stageColumnWidth,
        headerHeight:
            headerHeight,
        rowHeight:
            rowHeight,
        hourWidth:
            hourWidth,
        stageCount:
            timeline
                .stageRows
                .length,
        hourCount:
            timeline
                .hourMarkers
                .length,
        borderColor:
            colorScheme.outline,
        backgroundColor:
            colorScheme.surface,
        alternateColor:
            colorScheme
                .surfaceContainerHighest
                .withValues(
                  alpha: 0.22,
                ),
      ),
    );
  }
}

class _TimelineGridPainter
    extends CustomPainter {
  const _TimelineGridPainter({
    required this.stageColumnWidth,
    required this.headerHeight,
    required this.rowHeight,
    required this.hourWidth,
    required this.stageCount,
    required this.hourCount,
    required this.borderColor,
    required this.backgroundColor,
    required this.alternateColor,
  });

  final double stageColumnWidth;
  final double headerHeight;
  final double rowHeight;
  final double hourWidth;

  final int stageCount;
  final int hourCount;

  final Color borderColor;
  final Color backgroundColor;
  final Color alternateColor;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final fillPaint =
        Paint()
          ..color =
              backgroundColor;

    canvas.drawRect(
      Offset.zero & size,
      fillPaint,
    );

    final alternatePaint =
        Paint()
          ..color =
              alternateColor;

    for (
      var index = 0;
      index < stageCount;
      index++
    ) {
      if (index.isEven) {
        continue;
      }

      canvas.drawRect(
        Rect.fromLTWH(
          stageColumnWidth,
          headerHeight +
              index *
                  rowHeight,
          size.width -
              stageColumnWidth,
          rowHeight,
        ),
        alternatePaint,
      );
    }

    final linePaint =
        Paint()
          ..color =
              borderColor
          ..strokeWidth = 1;

    canvas.drawLine(
      Offset(
        stageColumnWidth,
        0,
      ),
      Offset(
        stageColumnWidth,
        size.height,
      ),
      linePaint,
    );

    canvas.drawLine(
      Offset(
        0,
        headerHeight,
      ),
      Offset(
        size.width,
        headerHeight,
      ),
      linePaint,
    );

    for (
      var row = 1;
      row <= stageCount;
      row++
    ) {
      final y =
          headerHeight +
          row *
              rowHeight;

      canvas.drawLine(
        Offset(0, y),
        Offset(
          size.width,
          y,
        ),
        linePaint,
      );
    }

    for (
      var hour = 0;
      hour <= hourCount;
      hour++
    ) {
      final x =
          stageColumnWidth +
          hour *
              hourWidth;

      canvas.drawLine(
        Offset(x, 0),
        Offset(
          x,
          size.height,
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _TimelineGridPainter
        oldDelegate,
  ) {
    return oldDelegate
                .stageCount !=
            stageCount ||
        oldDelegate
                .hourCount !=
            hourCount ||
        oldDelegate
                .borderColor !=
            borderColor ||
        oldDelegate
                .backgroundColor !=
            backgroundColor ||
        oldDelegate
                .alternateColor !=
            alternateColor;
  }
}

class _StageLabels
    extends StatelessWidget {
  const _StageLabels({
    required this.stageRows,
    required this.headerHeight,
    required this.rowHeight,
  });

  final List<_TimelineStageRow>
      stageRows;

  final double headerHeight;
  final double rowHeight;

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme =
        Theme.of(context)
            .colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            colorScheme.surface,
      ),
      child: Column(
        children: [
          SizedBox(
            height:
                headerHeight,
            child: Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 12,
              ),
              child: Align(
                alignment:
                    Alignment
                        .centerLeft,
                child: Text(
                  'Stage',
                  style:
                      Theme.of(
                    context,
                  )
                          .textTheme
                          .labelMedium,
                ),
              ),
            ),
          ),
          ...stageRows.asMap().entries.map(
            (entry) {
              final rowIndex =
                  entry.key;

              final stageRow =
                  entry.value;

              return ColoredBox(
                color:
                    rowIndex.isOdd
                        ? colorScheme
                            .surfaceContainerHighest
                            .withValues(
                              alpha:
                                  0.22,
                            )
                        : colorScheme
                            .surface,
                child: SizedBox(
                  height:
                      rowHeight,
                  child: Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal:
                          12,
                    ),
                    child: Align(
                      alignment:
                          Alignment
                              .centerLeft,
                      child: Text(
                        stageRow
                            .stageName,
                        maxLines: 2,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            Theme.of(
                          context,
                        )
                                .textTheme
                                .titleSmall,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineHeader
    extends StatelessWidget {
  const _TimelineHeader({
    required this.hourMarkers,
    required this.hourWidth,
  });

  final List<DateTime>
      hourMarkers;

  final double hourWidth;

  @override
  Widget build(
    BuildContext context,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            Theme.of(context)
                .colorScheme
                .surface,
      ),
      child: Stack(
        children: [
          for (
            var index = 0;
            index <
                hourMarkers.length;
            index++
          )
            Positioned(
              left:
                  index *
                  hourWidth,
              top: 0,
              width:
                  hourWidth,
              bottom: 0,
              child: Padding(
                padding:
                    const EdgeInsets
                        .only(
                  left: 10,
                ),
                child: Align(
                  alignment:
                      Alignment
                          .centerLeft,
                  child: Text(
                    DateFormat(
                      'HH:mm',
                    ).format(
                      hourMarkers[
                        index
                      ],
                    ),
                    style:
                        Theme.of(
                      context,
                    )
                            .textTheme
                            .labelMedium,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineSetCard
    extends StatelessWidget {
  const _TimelineSetCard({
    required this.positionedSet,
    required this.onLikePressed,
  });

  final _PositionedFestivalSet
      positionedSet;

  final VoidCallback onLikePressed;

  @override
  Widget build(
    BuildContext context,
  ) {
    final festivalSet =
        positionedSet.set;

    final timeText =
        '${DateFormat('HH:mm').format(
          toFestivalTime(
            festivalSet.startTime,
          ),
        )} – '
        '${DateFormat('HH:mm').format(
          toFestivalTime(
            festivalSet.endTime,
          ),
        )}';

    final colorScheme =
        Theme.of(context)
            .colorScheme;

    return Material(
      color:
          Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        onTap: () {
          // Later: open set details.
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              12,
            ),
            color:
                colorScheme.primary,
            image:
                festivalSet
                            .displayImage ==
                        null
                    ? null
                    : DecorationImage(
                        image:
                            CachedNetworkImageProvider(
                          festivalSet
                              .displayImage!,
                        ),
                        fit:
                            BoxFit.cover,
                      ),
            border: Border.all(
              color:
                  festivalSet.isLiked
                      ? colorScheme
                          .secondary
                      : Colors
                          .white24,
              width:
                  festivalSet.isLiked
                      ? 2
                      : 1,
            ),
          ),
          child: Stack(
            fit:
                StackFit.expand,
            children: [
              DecoratedBox(
                decoration:
                    BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                    11,
                  ),
                  gradient:
                      const LinearGradient(
                    begin:
                        Alignment
                            .topRight,
                    end:
                        Alignment
                            .bottomLeft,
                    colors: [
                      Color(
                        0x44000000,
                      ),
                      Color(
                        0xD9000000,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  10,
                  8,
                  34,
                  8,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  mainAxisAlignment:
                      MainAxisAlignment
                          .end,
                  children: [
                    Text(
                      festivalSet
                          .artistName,
                      maxLines:
                          positionedSet
                                      .width >=
                                  145
                              ? 2
                              : 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontWeight:
                            FontWeight
                                .w700,
                        fontSize:
                            13,
                        height:
                            1.05,
                      ),
                    ),
                    if (
                      positionedSet
                              .width >=
                          105
                    ) ...[
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        timeText,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          color:
                              Colors
                                  .white70,
                          fontSize:
                              10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Positioned(
                right: 3,
                top: 3,
                child:
                    IconButton(
                  visualDensity:
                      VisualDensity
                          .compact,
                  constraints:
                      const BoxConstraints(
                    minWidth:
                        30,
                    minHeight:
                        30,
                  ),
                  padding:
                      EdgeInsets.zero,
                  onPressed:
                      onLikePressed,
                  icon:
                      AnimatedSwitcher(
                    duration:
                        const Duration(
                      milliseconds:
                          160,
                    ),
                    child: Icon(
                      festivalSet
                              .isLiked
                          ? Icons
                              .favorite
                          : Icons
                              .favorite_border,
                      key:
                          ValueKey(
                        festivalSet
                            .isLiked,
                      ),
                      size: 18,
                      color:
                          festivalSet
                                  .isLiked
                              ? colorScheme
                                  .secondary
                              : Colors
                                  .white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineData {
  const _TimelineData({
    required this.timelineStart,
    required this.timelineEnd,
    required this.timelineWidth,
    required this.stageRows,
    required this.hourMarkers,
  });

  final DateTime timelineStart;
  final DateTime timelineEnd;

  final double timelineWidth;

  final List<_TimelineStageRow>
      stageRows;

  final List<DateTime>
      hourMarkers;
}

class _TimelineStageRow {
  const _TimelineStageRow({
    required this.stageName,
    required this.sets,
  });

  final String stageName;

  final List<_PositionedFestivalSet>
      sets;
}

class _PositionedFestivalSet {
  const _PositionedFestivalSet({
    required this.set,
    required this.left,
    required this.width,
  });

  final FestivalSet set;

  final double left;
  final double width;
}
