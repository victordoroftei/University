import React, {useCallback, useContext, useEffect, useState} from 'react';
import {
  IonButton,
  IonButtons,
  IonContent, IonDatetime,
  IonHeader,
  IonInput, IonItem, IonLabel,
  IonLoading,
  IonPage, IonSelect, IonSelectOption,
  IonTitle,
  IonToolbar
} from '@ionic/react';
import { getLogger } from '../core';
import { MovieContext } from './MovieProvider';
import { RouteComponentProps } from 'react-router';
import { MovieProps } from './MovieProps';
import {useNetwork} from "../network/useNetwork";
import {Plugins} from "@capacitor/core";

const log = getLogger('MovieEdit');

interface MovieEditProps extends RouteComponentProps<{
  id?: string;
}> {}

const MovieEdit: React.FC<MovieEditProps> = ({ history, match }) => {
  const { movies, saving, savingError, saveMovie } = useContext(MovieContext);
  const [title, setTitle] = useState('');
  const [releaseDate, setReleaseDate] = useState(new Date());
  const [hasThreeD, setHasThreeD] = useState(true);
  const [duration, setDuration] = useState(0);
  const [movie, setMovie] = useState<MovieProps>();
  const {networkStatus} = useNetwork();
  const {Storage} = Plugins;
  useEffect(() => {
    log('useEffect');
    const routeId = match.params.id || '';
    const movie = movies?.find(c => c._id === routeId);
    setMovie(movie);
    if (movie) {
      setTitle(movie.title);
      setReleaseDate(movie.releaseDate);
      setHasThreeD(movie.hasThreeD);
      setDuration(movie.duration);
    }
  }, [match.params.id, movies]);
  const handleSave = useCallback(() => {
    const editedMovie = movie ? { ...movie, title, releaseDate, hasThreeD, duration } : { title, releaseDate, hasThreeD, duration };

    if (networkStatus.connected) {
      saveMovie && saveMovie(editedMovie).then(() => history.goBack());
    }
    else {
      const saveMovieLocal = async () => {
        const savedMovies = await Storage.get({key:'users'});

        if (savedMovies.value) {
          var movies = JSON.parse(savedMovies.value);
          movies.push(editedMovie);
          await Storage.set({key:'users', value:JSON.stringify(movies)});
        }
        else {
          let movies = [editedMovie];
          await Storage.set({key:'users', value:JSON.stringify(movies)});
        }

        console.log(editedMovie);
        alert("The movie has been added in the list!");
      }
      saveMovieLocal().then(() => history.goBack());
    }

  }, [movie, saveMovie, title, releaseDate, hasThreeD, duration, history, networkStatus, Storage]);
  log('render');
  return (
      <IonPage>
        <IonHeader>
          <IonToolbar>
            <IonTitle>Edit Movie</IonTitle>
            <IonButtons slot="end">
              <IonButton onClick={handleSave}>
                Save Movie
              </IonButton>
            </IonButtons>
          </IonToolbar>
        </IonHeader>
        <IonContent>
          <IonItem>
            <IonLabel color="dark">Title</IonLabel>
            <IonInput placeholder={"Please enter the title of the movie"} value={title} onIonChange={e => setTitle(e.detail.value || '')} />
          </IonItem>
          <IonItem>
            <IonLabel color="dark">Release Date</IonLabel>
            <IonDatetime placeholder={"DD/MM/YYYY"} displayFormat="DD/MM/YYYY" value={releaseDate.toString()} onIonChange={e => setReleaseDate(new Date(e.detail.value || ''))} />
          </IonItem>
          <IonItem>
            <IonLabel color="dark">Duration (minutes)</IonLabel>
            <IonInput placeholder={(duration) ? duration.toString() : "Please enter the duration of the movie (in minutes)"} onIonChange={e => setDuration(parseInt(e.detail.value || ''))} />
          </IonItem>
          <IonItem>
            <IonLabel color="dark">Has 3D?</IonLabel>
            <IonSelect placeholder={hasThreeD.toString()} onIonChange={e => setHasThreeD(e.detail.value || '')}>
              <IonSelectOption key="true" value="true">True</IonSelectOption>
              <IonSelectOption key="false" value="false">False</IonSelectOption>
            </IonSelect>
          </IonItem>
          <IonLoading isOpen={saving} />
          {savingError && (
              <div>{savingError.message || 'Failed to save movie'}</div>
          )}
        </IonContent>
      </IonPage>
  );
};

export default MovieEdit;
