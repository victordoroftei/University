import { useEffect, useState } from 'react';
import {NetworkStatus, Plugins, Storage} from '@capacitor/core';
import {createMovie, updateMovie} from "../todo/MovieApi";

const { Network } = Plugins;

const initialState = {
    connected: false,
    connectionType: 'unknown',
}

export const useNetwork = () => {
    const [networkStatus, setNetworkStatus] = useState(initialState)
    useEffect(() => {
        const handler = Network.addListener('networkStatusChange', handleNetworkStatusChange);
        const handlerSave = Network.addListener('networkStatusChange', handleNetworkChangesSave)
        Network.getStatus().then(handleNetworkStatusChange);
        Network.getStatus().then(handleNetworkChangesSave);
        let canceled = false;
        return () => {
            canceled = true;
            handler.remove();
            handlerSave.remove();
        }

        function handleNetworkStatusChange(status: NetworkStatus) {
            if (!canceled) {
                setNetworkStatus(status);
            }
        }

        async function handleNetworkChangesSave(status: NetworkStatus) {
            if (status.connected) {
                let movies = await Storage.get({key: 'users'});

                if (movies.value) {
                    alert("The movies that are locally saved in the storage are being recovered");
                    let parsedMovies = JSON.parse(movies.value);
                    for (const movie of parsedMovies) {
                        await(movie._id ? updateMovie(localStorage.getItem('auth_token')!, movie): createMovie(localStorage.getItem('auth_token')!, movie));
                    }
                    await Storage.remove({key: 'users'});
                }
            }
        }
    }, [])
    return { networkStatus };
};