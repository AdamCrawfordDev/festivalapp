import apiClient from "./client";

import type {
    Artist,
    CreateSetRequest, CreateStageRequest,
    Festival,
    FestivalSet, PublicFestival,
    Stage,
} from "../types/festival";

export async function createFestival(
    formData: FormData,
): Promise<Festival> {
    const response = await apiClient.post<Festival>(
        "/festivals/",
        formData,
    );

    return response.data;
}

export async function getFestivals(): Promise<Festival[]> {
    const response = await apiClient.get<Festival[]>(
        "/festivals/",
    );

    return response.data;
}

export async function getFestival(
    festivalId: number,
): Promise<Festival> {
    const response = await apiClient.get<Festival>(
        `/festivals/${festivalId}/`,
    );

    return response.data;
}

export async function getStages(
    festivalId: number,
): Promise<Stage[]> {
    const response = await apiClient.get<Stage[]>(
        `/festivals/${festivalId}/stages/`,
    );

    return response.data;
}

export async function getSets(
    festivalId: number,
): Promise<FestivalSet[]> {
    const response = await apiClient.get<FestivalSet[]>(
        `/festivals/${festivalId}/sets/`,
    );

    return response.data;
}

export async function createSet(
    set: CreateSetRequest,
): Promise<FestivalSet> {
    const response = await apiClient.post<FestivalSet>(
        "/sets/",
        set,
    );

    return response.data;
}

export async function createStage(
    festivalId: number,
    stage: CreateStageRequest,
): Promise<Stage> {
    const response = await apiClient.post<Stage>(
        `/festivals/${festivalId}/stages/`,
        stage,
    );

    return response.data;
}

export type UpdateSetRequest = {
    stage: number;
    artist: number;
    start_time: string;
    end_time: string;
};

export async function updateSet(
    setId: number,
    data: UpdateSetRequest,
): Promise<FestivalSet> {
    const response = await apiClient.patch<FestivalSet>(
        `/festivals/sets/${setId}/`,
        data,
    );

    return response.data;
}



export async function getArtists(
    festivalId: number,
): Promise<Artist[]> {
    const response = await apiClient.get<Artist[]>(
        `/festivals/${festivalId}/artists/`,
    );

    return response.data;
}


export type CreateArtistRequest = {
    name: string;
};

export async function createArtist(
    festivalId: number,
    data: CreateArtistRequest,
): Promise<Artist> {
    const response = await apiClient.post<Artist>(
        `/festivals/${festivalId}/artists/`,
        data,
    );

    return response.data;
}

export async function getPublicFestivals():
    Promise<PublicFestival[]> {
    const response =
        await apiClient.get<PublicFestival[]>(
            "/festivals/discover/",
        );

    return response.data;
}


type ToggleSetLikeResponse = {
    set_id: number;
    is_liked: boolean;
    like_count: number;
};

export async function toggleSetLike(
    setId: number,
): Promise<ToggleSetLikeResponse> {
    const response =
        await apiClient.post<ToggleSetLikeResponse>(
            `/festivals/sets/${setId}/like/`,
        );

    return response.data;
}