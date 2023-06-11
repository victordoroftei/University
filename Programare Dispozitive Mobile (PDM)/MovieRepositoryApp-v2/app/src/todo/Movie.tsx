import React, { useCallback } from 'react';
import {IonCol, IonGrid, IonItem, IonLabel} from '@ionic/react';
import { MovieProps } from './MovieProps';

interface MoviePropsExt extends MovieProps {
  onEdit: (id?: string) => void;
}

const Movie: React.FC<MoviePropsExt> = ({ _id, title, releaseDate, hasThreeD, duration, onEdit }) => {
  const handleEdit = useCallback(() => onEdit(_id), [_id, onEdit]);
  return (
    <IonItem onClick={handleEdit}>
        <IonGrid>
            <IonCol>
                <IonLabel>Movie Title: {title}</IonLabel>
                <IonLabel>Movie Release Date: {new Date(releaseDate).toLocaleDateString()}</IonLabel>
                <IonLabel>Has 3D?: {hasThreeD.toString()}</IonLabel>
                <IonLabel>Duration (minutes): {duration}</IonLabel>
            </IonCol>
        </IonGrid>
    </IonItem>
  );
};

export default Movie;
