package com.example.movierepositoryapp.todo.data.remote

import com.example.movierepositoryapp.todo.data.Item

data class ItemEvent(val type: String, val payload: Item)
