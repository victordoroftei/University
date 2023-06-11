package com.example.movierepositoryapp

import android.content.Context
import android.util.Log
import androidx.datastore.preferences.preferencesDataStore
import com.example.movierepositoryapp.core.TAG
import com.example.movierepositoryapp.auth.data.AuthRepository
import com.example.movierepositoryapp.auth.data.remote.AuthDataSource
import com.example.movierepositoryapp.core.data.UserPreferencesRepository
import com.example.movierepositoryapp.core.data.remote.Api
import com.example.movierepositoryapp.todo.data.ItemRepository
import com.example.movierepositoryapp.todo.data.remote.ItemService
import com.example.movierepositoryapp.todo.data.remote.ItemWsClient

val Context.userPreferencesDataStore by preferencesDataStore(
    name = "user_preferences"
)

class AppContainer(val context: Context) {
    init {
        Log.d(TAG, "init")
    }

    private val itemService: ItemService = Api.retrofit.create(ItemService::class.java)
    private val itemWsClient: ItemWsClient = ItemWsClient(Api.okHttpClient)
    private val authDataSource: AuthDataSource = AuthDataSource()

    private val database: MyAppDatabase by lazy { MyAppDatabase.getDatabase(context) }

    val itemRepository: ItemRepository by lazy {
        ItemRepository(itemService, itemWsClient, database.itemDao())
    }

    val authRepository: AuthRepository by lazy {
        AuthRepository(authDataSource)
    }

    val userPreferencesRepository: UserPreferencesRepository by lazy {
        UserPreferencesRepository(context.userPreferencesDataStore)
    }
}
