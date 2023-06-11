import Router from 'koa-router';
import movieStore from './store';
import { broadcast } from "../utils";

export const router = new Router();

router.get('/', async (ctx) => {
  const response = ctx.response;
  const userId = ctx.state.user._id;
  response.body = await movieStore.find({ userId });
  response.status = 200; // ok
});

router.get('/:id', async (ctx) => {
  const userId = ctx.state.user._id;
  const movie = await movieStore.findOne({ _id: ctx.params.id });
  const response = ctx.response;
  if (movie) {
    if (movie.userId === userId) {
      response.body = movie;
      response.status = 200; // ok
    } else {
      response.status = 403; // forbidden
    }
  } else {
    response.status = 404; // not found
  }
});

const createMovie = async (ctx, movie, response) => {
  try {
    const userId = ctx.state.user._id;
    movie.userId = userId;
    response.body = await movieStore.insert(movie);
    response.status = 201; // created
    movie._id = response.body._id;
    broadcast(userId, { type: 'created', payload: movie });
  } catch (err) {
    response.body = { message: err.message };
    response.status = 400; // bad request
  }
};

router.post('/', async ctx => await createMovie(ctx, ctx.request.body, ctx.response));

router.put('/:id', async (ctx) => {
  const movie = ctx.request.body;
  const id = ctx.params.id;
  const movieId = movie._id;
  const response = ctx.response;
  if (movieId && movieId !== id) {
    response.body = { message: 'Param id and body _id should be the same' };
    response.status = 400; // bad request
    return;
  }
  if (!movieId) {
    await createMovie(ctx, movie, response);
  } else {
    const userId = ctx.state.user._id;
    movie.userId = userId;
    const updatedCount = await movieStore.update({ _id: id }, movie);
    if (updatedCount === 1) {
      response.body = movie;
      response.status = 200; // ok
      broadcast(userId, { type: 'updated', payload: movie });
    } else {
      response.body = { message: 'Resource no longer exists' };
      response.status = 405; // method not allowed
    }
  }
});

router.del('/:id', async (ctx) => {
  const userId = ctx.state.user._id;
  const movie = await movieStore.findOne({ _id: ctx.params.id });
  if (movie && userId !== movie.userId) {
    ctx.response.status = 403; // forbidden
  } else {
    await movieStore.remove({ _id: ctx.params.id });
    ctx.response.status = 204; // no content
  }
});
