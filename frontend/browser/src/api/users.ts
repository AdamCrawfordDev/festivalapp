import type {FestivalSet, PublicFestival, Stage} from "../types/festival.ts";
import apiClient from "./client.ts";

export async function getPublicFestivals():
    Promise<PublicFestival[]> {
    const response =
        await apiClient.get<PublicFestival[]>(
            "/festivals/discover/",
        );

    return response.data;
}

export async function getPublicFestival(
    festivalId: number,
): Promise<PublicFestival> {
    const response =
        await apiClient.get<PublicFestival>(
            `/festivals/discover/${festivalId}/`,
        );

    return response.data;
}

export async function getPublicFestivalSets(
    festivalId: number,
): Promise<FestivalSet[]> {
    const response =
        await apiClient.get<FestivalSet[]>(
            `/festivals/discover/${festivalId}/sets/`,
        );

    return response.data;
}

export async function getPublicFestivalStages(
    festivalId: number,
): Promise<Stage[]> {
    const response =
        await apiClient.get<Stage[]>(
            `/festivals/discover/${festivalId}/stages/`,
        );

    return response.data;
}