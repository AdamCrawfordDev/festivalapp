import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/festival.dart';
import '../models/festival_set.dart';
import '../models/stage.dart';
import 'api_client.dart';

class ToggleSetLikeResult {
  const ToggleSetLikeResult({
    required this.setId,
    required this.isLiked,
    required this.likeCount,
  });

  final int setId;
  final bool isLiked;
  final int likeCount;

  factory ToggleSetLikeResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return ToggleSetLikeResult(
      setId: json['set_id'] as int,
      isLiked:
          json['is_liked'] as bool,
      likeCount:
          json['like_count'] as int,
    );
  }
}

class FestivalsApi {
  FestivalsApi(this._dio);

  final Dio _dio;

  Future<List<Festival>>
      getFestivals() async {
    final response =
        await _dio.get<dynamic>(
      '/festivals/discover/',
    );

    final data = response.data;

    if (data is! List) {
      throw const FormatException(
        'Expected the festival discovery '
        'endpoint to return a list.',
      );
    }

    return data.map((item) {
      return Festival.fromJson(
        Map<String, dynamic>.from(
          item as Map,
        ),
      );
    }).toList();
  }

  Future<Festival> getFestival(
    int festivalId,
  ) async {
    final response =
        await _dio.get<dynamic>(
      '/festivals/discover/'
      '$festivalId/',
    );

    return Festival.fromJson(
      Map<String, dynamic>.from(
        response.data as Map,
      ),
    );
  }

  Future<List<Stage>> getStages(
    int festivalId,
  ) async {
    final response =
        await _dio.get<dynamic>(
      '/festivals/discover/'
      '$festivalId/stages/',
    );

    final data = response.data;

    if (data is! List) {
      throw const FormatException(
        'Expected the stage endpoint '
        'to return a list.',
      );
    }

    return data.map((item) {
      return Stage.fromJson(
        Map<String, dynamic>.from(
          item as Map,
        ),
      );
    }).toList();
  }

  Future<List<FestivalSet>> getSets(
    int festivalId,
  ) async {
    final response =
        await _dio.get<dynamic>(
      '/festivals/discover/'
      '$festivalId/sets/',
    );

    final data = response.data;

    if (data is! List) {
      throw const FormatException(
        'Expected the set endpoint '
        'to return a list.',
      );
    }

    return data.map((item) {
      return FestivalSet.fromJson(
        Map<String, dynamic>.from(
          item as Map,
        ),
      );
    }).toList();
  }

  Future<ToggleSetLikeResult>
      toggleSetLike(
    int setId,
  ) async {
    final response =
        await _dio.post<dynamic>(
      '/festivals/sets/'
      '$setId/like/',
    );

    return ToggleSetLikeResult.fromJson(
      Map<String, dynamic>.from(
        response.data as Map,
      ),
    );
  }
}

final festivalsApiProvider =
    Provider<FestivalsApi>((ref) {
  return FestivalsApi(
    ref.watch(dioProvider),
  );
});