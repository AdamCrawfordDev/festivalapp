export type Festival = {
    id: number;
    name: string;
    description: string;
    start_date: string;
    end_date: string;
    organiser: number;
    image: string | null;
    created_at: string;
    updated_at: string;
};

export type Stage = {
    id: number;
    festival: number;
    name: string;
};

export type FestivalSet = {
    id: number;

    stage: number;
    stage_name: string;

    artist: number;
    artist_name: string;

    start_time: string;
    end_time: string;

    image: string | null;

    is_liked: boolean;
    like_count: number;
};

export type CreateStageRequest = {
    name: string;
};

export type CreateSetRequest = {
    stage: number;
    artist: string;
    start_time: string;
    end_time: string;
};

export type Artist = {
    id: number;
    festival: number;
    name: string;
    description: string;
    image: string | null;
    created_at: string;
    updated_at: string;
};

export type PublicFestival = {
    id: number;

    name: string;
    description: string;

    start_date: string;
    end_date: string;

    image: string | null;

    organiser_name: string;
    organiser_profile_picture: string | null;
};