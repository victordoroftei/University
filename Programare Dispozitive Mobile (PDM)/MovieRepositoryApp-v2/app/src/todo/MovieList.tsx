import React, {useContext, useEffect, useState} from 'react';
import { RouteComponentProps } from 'react-router';
import {
  IonContent,
  IonFab,
  IonFabButton,
  IonHeader,
  IonIcon, IonInfiniteScroll, IonInfiniteScrollContent,
  IonList, IonLoading,
  IonPage, IonSearchbar, IonSelect, IonSelectOption,
  IonTitle,
  IonToolbar, useIonViewWillEnter
} from '@ionic/react';
import {add, logOut} from 'ionicons/icons';
import Movie from '../../../../MovieRepositoryApp-v2/app/src/todo/Movie';
import { getLogger } from '../core';
import { MovieContext } from './MovieProvider';
import {AuthContext} from "../auth";
import NetworkStatus from "../network/networkStatus";
import {MovieProps} from "./MovieProps";

const log = getLogger('MovieList');

interface MovieScroll {
  viewMovies: MovieProps[],
  counter: number,
  disableInfiniteScroll: boolean
}

const initialState: MovieScroll = {
  viewMovies: [],
  counter: 0,
  disableInfiniteScroll: false
}

const MovieList: React.FC<RouteComponentProps> = ({ history }) => {
  const { movies, fetching, fetchingError } = useContext(MovieContext);
  const {logout} = useContext(AuthContext);
  const [searchMovie, setSearchMovie] = useState<string>('');
  const [filterMovie, setFilterMovie] = useState<string>('*');
  const [state, setState] = useState<MovieScroll>(initialState);
  const {counter, viewMovies, disableInfiniteScroll} = state;
  const handleLogout = () => {
    log("handleLogout...");
    logout?.();
  }

  useEffect(() => {
    fetchData();
  }, [movies]);

  async function fetchData() {
    let newMovies = movies?.slice(0, counter + 5);

    if (newMovies == null) {
      newMovies = [];
    }

    let disable = viewMovies.length === newMovies.length;
    setState({viewMovies: newMovies, counter: counter + 5, disableInfiniteScroll: disable})
  }

  async function searchNext($event: CustomEvent<void>) {
    await fetchData();
    ($event.target as HTMLIonInfiniteScrollElement).complete();
  }

  log('render');
  return (
      <IonPage>
        <IonHeader>
          <IonToolbar>
            <IonTitle>My Movies App</IonTitle>
          </IonToolbar>
          <NetworkStatus></NetworkStatus>
          <IonSearchbar debounce={1000} value={searchMovie} onIonChange={e => setSearchMovie(e.detail.value!)}/>
            <IonSelect placeholder={"Filter movies by duration"} onIonChange={e => setFilterMovie(e.detail.value || '')}>
              <IonSelectOption value="*">All</IonSelectOption>
              <IonSelectOption value="90">90</IonSelectOption>
              <IonSelectOption value="120">120</IonSelectOption>
              <IonSelectOption value="150">150</IonSelectOption>
            </IonSelect>
        </IonHeader>
        <IonContent>
          <IonLoading isOpen={fetching} message="Fetching movies" />
          {viewMovies && (
              <IonList>
                {viewMovies.filter(movie => movie.title.toLowerCase().includes(searchMovie.toLowerCase()))
                    .filter(movie => (filterMovie !== undefined && filterMovie !== '*') ? movie.duration <= parseInt(filterMovie) : true)
                    .map(({ _id, title, releaseDate, hasThreeD, duration}) =>
                    <Movie key={_id} _id={_id} title={title} releaseDate={releaseDate} duration={duration} hasThreeD={hasThreeD} onEdit={id => history.push(`/movie/${id}`)} />)}
              </IonList>
          )}
          <IonInfiniteScroll threshold="100px"
                             onIonInfinite={(e: CustomEvent<void>) => searchNext(e)}
                             disabled={disableInfiniteScroll}>
            <IonInfiniteScrollContent
                loadingText="Loading more movies...">
            </IonInfiniteScrollContent>
          </IonInfiniteScroll>
          {fetchingError && (
              <div>{fetchingError.message || 'Failed to fetch movies'}</div>
          )}
          <IonFab vertical="bottom" horizontal="start" slot="fixed">
            <IonFabButton onClick={() => handleLogout()}>
              <IonIcon icon={logOut} />
            </IonFabButton>
          </IonFab>
          <IonFab vertical="bottom" horizontal="end" slot="fixed">
            <IonFabButton onClick={() => history.push('/movie')}>
              <IonIcon icon={add} />
            </IonFabButton>
          </IonFab>
        </IonContent>
      </IonPage>
  );
};

export default MovieList;
