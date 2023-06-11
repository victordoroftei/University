package com.example.movierepositoryapp.todo.ui.item

import android.app.DatePickerDialog
import android.util.Log
import android.widget.DatePicker
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.movierepositoryapp.R
import java.util.*

@Composable
fun ItemScreen(itemId: String?, onClose: () -> Unit) {
    val itemViewModel = viewModel<ItemViewModel>(factory = ItemViewModel.Factory(itemId))
    val itemUiState = itemViewModel.uiState
    var title by rememberSaveable { mutableStateOf(itemUiState.item?.title ?: "") }
    var duration by rememberSaveable { mutableStateOf(itemUiState.item?.duration ?: "90") }
    var releaseDate by rememberSaveable { mutableStateOf(itemUiState.item?.releaseDate ?: "") }
    var hasThreeD by rememberSaveable { mutableStateOf(itemUiState.item?.hasThreeD ?: "false") }

    // Date picker
    val context = LocalContext.current
    val year: Int
    val month: Int
    val day: Int
    val calendar = Calendar.getInstance()

    year = calendar.get(Calendar.YEAR)
    month = calendar.get(Calendar.MONTH)
    day = calendar.get(Calendar.DAY_OF_MONTH)

    calendar.time = Date()
    val DatePickerDialog = DatePickerDialog(
        context,
        { _: DatePicker, year: Int, month: Int, dayOfMonth: Int ->
            releaseDate = "$dayOfMonth/${month + 1}/$year"
        }, year, month, day
    )

    // Has 3D radio buttons
    val hasThreeDValues = listOf("true", "false")
    val (selectedHasThreeD, onHasThreeDSelected) = remember { mutableStateOf("") }

    Log.d("ItemScreen", "recompose, title = $title")

    LaunchedEffect(itemUiState.savingCompleted) {
        Log.d("ItemScreen", "Saving completed = ${itemUiState.savingCompleted}");
        if (itemUiState.savingCompleted) {
            onClose();
        }
    }

    var textInitialized by remember { mutableStateOf(itemId == null) }
    LaunchedEffect(itemId, itemUiState.isLoading) {
        Log.d("ItemScreen", "Saving completed = ${itemUiState.savingCompleted}");
        if (textInitialized) {
            return@LaunchedEffect
        }
        if (itemUiState.item != null && !itemUiState.isLoading) {
            title = itemUiState.item.title
            duration = itemUiState.item.duration
            releaseDate = itemUiState.item.releaseDate
            hasThreeD = itemUiState.item.hasThreeD
            textInitialized = true
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(text = stringResource(id = R.string.item)) },
                actions = {
                    Button(onClick = {
                        Log.d("ItemScreen", "Save Movie Title = $title");
                        itemViewModel.saveOrUpdateItem(title, duration, releaseDate, hasThreeD)
                    }) { Text("Save") }
                }
            )
        }
    ) {
        if (itemUiState.isLoading) {
            CircularProgressIndicator()
            return@Scaffold
        }
        if (itemUiState.loadingError != null) {
            Text(text = "Failed to load item - ${itemUiState.loadingError.message}")
        }
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(24.dp)
        ) {
            TextField(
                value = title,
                onValueChange = { title = it },
                label = { Text("Title") },
                modifier = Modifier.fillMaxWidth()
            )
            TextField(
                value = duration,
                onValueChange = { duration = it },
                label = { Text("Duration (in minutes)") },
                modifier = Modifier.fillMaxWidth()
            )
            Column {
                Button(onClick = {
                    DatePickerDialog.show()
                }, colors = ButtonDefaults.buttonColors(backgroundColor = Color(0XFF0F9D58)) ) {
                    Text(text = "Choose the release date", color = Color.White)
                }
                Spacer(modifier = Modifier.size(20.dp))
                Text(text = "Selected Release Date: $releaseDate", fontSize = 20.sp)
            }
            Spacer(modifier = Modifier.size(20.dp))
            Text(
                text = "Has 3D:",
                style = MaterialTheme.typography.body1.merge(),
                modifier = Modifier.padding(start = 16.dp)
            )
            Column(Modifier.selectableGroup()) {
                hasThreeDValues.forEach { text ->
                    Row(
                        Modifier
                            .fillMaxWidth()
                            .height(56.dp)
                            .selectable(
                                selected = (text == hasThreeD),
                                onClick = { onHasThreeDSelected(text); hasThreeD = text },
                                role = Role.RadioButton
                            )
                            .padding(horizontal = 16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(
                            selected = (text == hasThreeD),
                            onClick = null
                        )
                        Text(
                            text = text,
                            style = MaterialTheme.typography.body1.merge(),
                            modifier = Modifier.padding(start = 16.dp)
                        )
                    }
                }
            }
        }
        if (itemUiState.isSaving) {
            Column(
                Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally
            ) { LinearProgressIndicator() }
        }
        if (itemUiState.savingError != null) {
            Text(text = "Failed to save item - ${itemUiState.savingError.message}")
        }
    }
}

@Preview
@Composable
fun PreviewItemScreen() {
    ItemScreen(itemId = "0", onClose = {})
}
