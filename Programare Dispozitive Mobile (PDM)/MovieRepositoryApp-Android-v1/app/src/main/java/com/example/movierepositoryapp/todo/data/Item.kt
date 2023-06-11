package com.example.movierepositoryapp.todo.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "items")
data class Item(
    @PrimaryKey val _id: String = "",
    val title: String = "",
    val duration: String = "",
    val releaseDate: String = "",
    var hasThreeD: String = ""
)
