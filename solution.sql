CREATE TABLE public.users ( userid integer NOT NULL, name text COLLATE pg_catalog."default", CONSTRAINT users_pkey PRIMARY KEY (userid));

CREATE TABLE public.movies (movieid integer NOT NULL, title text COLLATE pg_catalog."default", CONSTRAINT movies_pkey PRIMARY KEY (movieid));

CREATE TABLE public.taginfo (tagid integer NOT NULL, content text COLLATE pg_catalog."default", CONSTRAINT taginfo_pkey PRIMARY KEY (tagid));

CREATE TABLE public.genres ( genreid integer NOT NULL, name text COLLATE pg_catalog."default", CONSTRAINT genres_pkey PRIMARY KEY (genreid));

CREATE TABLE public.ratings( userid integer NOT NULL, movieid integer NOT NULL, rating numeric, "timestamp" bigint, CONSTRAINT ratings_pkey PRIMARY KEY (userid, movieid), CONSTRAINT ratings_movieid_fkey FOREIGN KEY (movieid) REFERENCES public.movies (movieid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE, CONSTRAINT ratings_userid_fkey FOREIGN KEY (userid) REFERENCES public.users (userid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE, CONSTRAINT ratings_rating_check CHECK (rating >= 0::numeric), CONSTRAINT ratings_rating_check1 CHECK (rating <= 5::numeric));

CREATE TABLE public.tags (userid integer NOT NULL, movieid integer NOT NULL, tagid integer NOT NULL, "timestamp" bigint, CONSTRAINT tags_pkey PRIMARY KEY (userid, movieid, tagid), CONSTRAINT tags_movieid_fkey FOREIGN KEY (movieid) REFERENCES public.movies (movieid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE, CONSTRAINT tags_tagid_fkey FOREIGN KEY (tagid) REFERENCES public.taginfo (tagid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE, CONSTRAINT tags_userid_fkey FOREIGN KEY (userid) REFERENCES public.users (userid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE public.hasagenre ( movieid integer NOT NULL, genreid integer NOT NULL, CONSTRAINT hasagenre_pkey PRIMARY KEY (movieid, genreid), CONSTRAINT hasagenre_genreid_fkey FOREIGN KEY (genreid) REFERENCES public.genres (genreid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE, CONSTRAINT hasagenre_movieid_fkey FOREIGN KEY (movieid) REFERENCES public.movies (movieid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE);
