package com.example.movierepositoryapp.todo.ui.items

import android.util.Log
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.ClickableText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.movierepositoryapp.todo.data.Item

typealias OnItemFn = (id: String?) -> Unit

@Composable
fun ItemList(itemList: List<Item>, onItemClick: OnItemFn) {
    Log.d("ItemList", "recompose")
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(12.dp)
    ) {
        items(itemList) { item ->
            ItemDetail(item, onItemClick)
        }
    }
}

@Composable
fun ItemDetail(item: Item, onItemClick: OnItemFn) {
//    Log.d("ItemDetail", "recompose id = ${item._id}")
    Row {
        ClickableText(
            text = AnnotatedString(
                "Title: " + item.title + "\nDuration (in minutes): " + item.duration +
                        "\nRelease Date: " + item.releaseDate + "\nHas 3D: " + item.hasThreeD + "\n\n"),
            style = TextStyle(
                fontSize = 24.sp,
            ),
            onClick = { onItemClick(item._id) }
        )
    }
}
