import dataStore from 'nedb-promise';

export class MovieStore {
  constructor({ filename, autoload }) {
    this.store = dataStore({ filename, autoload });
  }
  
  async find(props) {
    return this.store.find(props);
  }
  
  async findOne(props) {
    return this.store.findOne(props);
  }
  
  async insert(movie) {
    if (!movie.title) { // validation
      throw new Error("Movie title is missing!")
    }
    if (!movie.duration) {
      throw new Error("Movie duration is missing!")
    }
    if (!movie.releaseDate) {
      throw new Error("Movie release date is missing!")
    }
    if (!movie.hasThreeD) {
      throw new Error("Has 3D is missing!")
    }

    return this.store.insert(movie);
  };
  
  async update(props, movie) {
    return this.store.update(props, movie);
  }
  
  async remove(props) {
    return this.store.remove(props);
  }
}

export default new MovieStore({ filename: './db/movies.json', autoload: true });
