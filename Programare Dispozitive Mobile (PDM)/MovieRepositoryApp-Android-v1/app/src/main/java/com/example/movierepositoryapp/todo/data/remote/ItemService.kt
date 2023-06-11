package com.example.movierepositoryapp.todo.data.remote

import com.example.movierepositoryapp.todo.data.Item
import retrofit2.http.*

interface ItemService {
    @GET("/api/movie")
    suspend fun find(): List<Item>

    @GET("/api/movie/{id}")
    suspend fun read(@Path("id") itemId: String?): Item;

    @Headers("Content-Type: application/json")
    @POST("/api/movie")
    suspend fun create(@Body item: Item): Item

    @Headers("Content-Type: application/json")
    @PUT("/api/movie/{id}")
    suspend fun update(@Path("id") itemId: String?, @Body item: Item): Item
}
