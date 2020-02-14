
;(function() {

  // lodash - основная функция для библиотеки
  function libFunc(value) {
  }

  // Добавляем новую функцию
  libFunc.helloMy = function(){
    alert('Hello!');
  }




  libFunc.render_create_form = function (currentUser_id, show_user_id){

    // получение формы контейнера
    var area = document.getElementById("new_note_area");

    // затираем то что было до этого
    area.innerHTML = "";

    // ==== создание разметки создания заметки ====
    // фома создания
    var x = document.createElement("FORM");
    x.setAttribute("name", "create_note_form");
    x.setAttribute("style", "padding-left: 10px");
    x.setAttribute("onsubmit", "return MyLib.createAsk(" + currentUser_id + ", " + show_user_id + ")");

    // x.addEventListener("submit", e => { createAsk(currentUser_id, show_user_id)}, false);
    area.appendChild(x);


    // метка заголовка
    var titleLable = document.createElement("LABEL");
    titleLable.setAttribute("for", "title");
    titleLable.innerHTML = "Заголовок: ";
    x.appendChild(titleLable);

    // поле заголовка
    var titleInput = document.createElement("INPUT");
    titleInput.setAttribute("type", "text");
    titleInput.setAttribute("name", "title");
    x.appendChild(titleInput);

    // перенос строки
    x.innerHTML = x.innerHTML + "<br>";

    // метка тела заметки
    var areaLable = document.createElement("LABEL");
    areaLable.setAttribute("for", "body_text");
    areaLable.innerHTML = "Текст: ";
    x.appendChild(areaLable);

    // тело заметки
    var textArea = document.createElement("TEXTAREA");
    textArea.setAttribute("style", "margin: 0px; width: 295px; height: 165px");
    textArea.setAttribute("name", "body_text");
    x.appendChild(textArea);

    // перенос строки
    x.innerHTML = x.innerHTML + "<br>";

    // метка чекбокса
    var checkboxLable = document.createElement("LABEL");
    checkboxLable.setAttribute("for", "is_public");
    checkboxLable.innerHTML = "Публичная заметка:";
    x.appendChild(checkboxLable);

    // чекбокс
    var checkbox = document.createElement("INPUT");
    checkbox.setAttribute("type", "checkbox");
    checkbox.setAttribute("name", "is_public");
    checkbox.setAttribute("checked","checked");
    x.appendChild(checkbox);

    // перенос строки
    x.innerHTML = x.innerHTML + "<br><br>";

    // кнопка ввода
    var button = document.createElement("INPUT");
    button.setAttribute("type", "SUBMIT");
    button.setAttribute("value", "Добавить заметку");
    x.appendChild(button);

    // перенос строки
    area.innerHTML = area.innerHTML + "<br>";

    return false;
  }

  libFunc.createAsk = function(currentUser_id, show_user_id){
    // POST запрос на создание заметки
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/users/" + show_user_id + "/notes/new.json", true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
      var done = 4, ok = 200;
      if (xhr.readyState == done && xhr.status == ok) {
        // после успешного создания заметки
        my_JSON_object = JSON.parse(xhr.responseText);
        libFunc.createAnswer(my_JSON_object, currentUser_id, show_user_id);
      }
    };
    xhr.send(
     'title=' + encodeURIComponent(document.forms.create_note_form.title.value) +
     '&body_text=' + encodeURIComponent(document.forms.create_note_form.body_text.value) +
     '&is_public=' + encodeURIComponent(document.forms.create_note_form.is_public.checked)
   );
    return false;
  }

  libFunc.createAnswer = function(data, currentUser_id, show_user_id){

          // формируем html
          let html_answer = "<h3>Заметка "
          if(!data.is_public){
            html_answer = html_answer + "приватная"
          }
          html_answer = html_answer + " от " + libFunc.formatStringDateToText(data.when_created) + "</h3>"+//тут дата
            "<h3>"+ libFunc.myTextToHTMLText(data.title) + "</h3>"+
            libFunc.myTextToHTMLText(data.body_text)+"<br><br>";


          // главный контейнер html
          var result = document.createElement("div")
          result.innerHTML = html_answer;
          result.setAttribute("id", "note_area_" + data.note_id);
          result.setAttribute("style","margin: 5px");
          result.setAttribute("class", (data.is_public ? "note" : "private_note"));
          // выводим html ответа над зоной новых заметок
          document.getElementById("note_area").insertBefore(
            result,
            document.getElementById("new_note_area")
          );

          if(show_user_id == currentUser_id){
            // кнопка удаления записи
            var buttonRemove = document.createElement("BUTTON");
            buttonRemove.setAttribute("type", "submit");
            buttonRemove.setAttribute("value", "Сохранить заметку");
            buttonRemove.innerHTML = 'Удалить';
            buttonRemove.addEventListener('click', function(){ libFunc.deleteAsk(data.note_id, show_user_id); }, false);
            result.appendChild(buttonRemove);
            // кнопка редактирования записи
            var button = document.createElement("BUTTON");
            button.setAttribute("type", "submit");
            button.setAttribute("value", "Сохранить заметку");
            button.innerHTML = 'Редактировать';
            button.addEventListener('click', function(){ libFunc.render_edit_form(data.note_id, data.title, data.body_text, data.is_public, currentUser_id, show_user_id) }, false);
            result.appendChild(button);
          }



          // обнуляем зону создания
          document.getElementById("new_note_area").innerHTML =
            "<button style=\"margin: 5px\" id=\"new_note_button\" onclick=\"return MyLib.render_create_form(" + currentUser_id + ", " + show_user_id + ");\">Новая заметка</button>";

  }







  libFunc.render_edit_form = function(note_id, title, body_text, is_public, currentUser_id, show_user_id){

    // получение формы контейнера
    var area = document.getElementById("note_area_" + note_id);

    // ==== создание разметки редактора заметки ====
    // фома редактирования
    var x = document.createElement("FORM");
    x.setAttribute("id", "edit_note_form_" + note_id);
    x.setAttribute("name", "edit_note_form_" + note_id);
    x.setAttribute("onsubmit", "return MyLib.updateAsk("+note_id+", "+currentUser_id+", "+show_user_id+")");
    //x.onsubmit = function(){return updateAsk(note_id, title, body_text, is_public, currentUser_id, show_user_id);}
    x.setAttribute("style", "padding-left: 10px");

    // метка заголовка
    var titleLable = document.createElement("LABEL");
    titleLable.setAttribute("for", "title");
    titleLable.innerHTML = "Заголовок: ";
    x.appendChild(titleLable);

    // поле заголовка
    var titleInput = document.createElement("INPUT");
    titleInput.setAttribute("type", "text");
    titleInput.setAttribute("name", "title");
    titleInput.setAttribute("value", title);
    x.appendChild(titleInput);

    // перенос строки
    x.innerHTML = x.innerHTML + "<br>";

    // метка тела заметки
    var areaLable = document.createElement("LABEL");
    areaLable.setAttribute("for", "body_text");
    areaLable.innerHTML = "Текст: ";
    x.appendChild(areaLable);

    // тело заметки
    var textArea = document.createElement("TEXTAREA");
    textArea.setAttribute("style", "margin: 0px; width: 295px; height: 165px");
    textArea.setAttribute("name", "body_text");
    textArea.innerHTML = body_text;
    x.appendChild(textArea);

    // перенос строки
    x.innerHTML = x.innerHTML + "<br>";

    // метка чекбокса
    var checkboxLable = document.createElement("LABEL");
    checkboxLable.setAttribute("for", "is_public");
    checkboxLable.innerHTML = "Публичная заметка:";
    x.appendChild(checkboxLable);

    // чекбокс
    var checkbox = document.createElement("INPUT");
    checkbox.setAttribute("type", "checkbox");
    checkbox.setAttribute("name", "is_public");
    if(is_public){checkbox.setAttribute("checked","checked");}
    x.appendChild(checkbox);

    // перенос строки
    x.innerHTML = x.innerHTML + "<br><br>";

    // кнопка ввода
    var button = document.createElement("INPUT");
    button.setAttribute("type", "submit");
    button.setAttribute("value", "Сохранить заметку");
    x.appendChild(button);


    // затираем то что было до этого
    area.innerHTML = "";

    area.appendChild(x);
    area.innerHTML = area.innerHTML + "<br>";

    return false;
  }

  libFunc.updateAsk = function(note_id, currentUser_id, show_user_id){

    // POST запрос на редактирование заметки
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/users/" + show_user_id + "/notes/" + note_id + "/change.json", true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
      var done = 4, ok = 200;
      if (xhr.readyState == done && xhr.status == ok) {
        // после успешного создания заметки
        data = JSON.parse(xhr.responseText);
        // обновляем содержимое страницы
        let area_update = document.getElementById("note_area_" + data.note_id);
        area_update.innerHTML = "";
        area_update.setAttribute("class", (data.is_public ? "note" : "private_note"));
        let html_answer = "<h3>Заметка "
        if(!data.is_public){
          html_answer = html_answer + "приватная"
        }
        html_answer = html_answer + " от " + libFunc.formatStringDateToText(data.when_created) + "</h3>"+// тут дата
          "<h3>" + libFunc.myTextToHTMLText(data.title) + "</h3>" + libFunc.myTextToHTMLText(data.body_text) +"<br><br>";
        area_update.innerHTML = html_answer;

        // если это аккаунт этого пользователя
        if(show_user_id == currentUser_id){
          // кнопка удаления записи
          let buttonRemove = document.createElement("BUTTON");
          buttonRemove.setAttribute("type", "submit");
          buttonRemove.setAttribute("value", "Сохранить заметку");
          buttonRemove.innerHTML = 'Удалить';
          buttonRemove.addEventListener('click', function(){ libFunc.deleteAsk(data.note_id, show_user_id); }, false);
          area_update.appendChild(buttonRemove);
          // кнопка редактирования записи
          let button = document.createElement("BUTTON");
          button.setAttribute("type", "submit");
          button.setAttribute("value", "Сохранить заметку");
          button.innerHTML = 'Редактировать';
          button.addEventListener('click', function(){ libFunc.render_edit_form(data.note_id, data.title, data.body_text, data.is_public, currentUser_id, show_user_id) }, false);
          area_update.appendChild(button);
        }
      }
    };

    xhr.send(
     'title=' + encodeURIComponent(document.forms['edit_note_form_' + note_id].elements['title'].value) +
     '&body_text=' + encodeURIComponent(document.forms['edit_note_form_' + note_id].elements['body_text'].value) +
     '&is_public=' + encodeURIComponent(document.forms['edit_note_form_' + note_id].elements['is_public'].checked)
    );
    return false;

  }





  libFunc.deleteAsk = function(note_id, show_user_id){
    // подтверждение удаления
    if(confirm('Удалить заметку?')){
      // DELETE запрос на удаление заметки
      let xhr = new XMLHttpRequest();
      xhr.open("DELETE", "/users/" + show_user_id + "/notes/" + note_id + "/delete.json", true);
      xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
      xhr.onreadystatechange = function () {

        let done = 4;
        if (xhr.readyState == done){// когда процесс завершен
          if(xhr.status == 200) {// после успешного удаления заметки
            my_JSON_object = JSON.parse(xhr.responseText);
            if(my_JSON_object.isDestroyed){
              // удаляем заметку со страницы
              elem = document.getElementById("note_area_" + note_id);
              if(elem != null){
                elem.remove();
              }
            }else{
                alert('Ошибка удаления, ');
            }
          } else if(xhr.status == 403){
            alert('Ошибка 403, у вас нет прав на удаление этой записи');
          }
        }
      };
      xhr.send();
    }
    return false;
  }




  libFunc.formatStringDateToText = function(sDate){
    let date = new Date(sDate);
    return "" + date.getFullYear() + "-" + libFunc.getTwoSymbols(date.getMonth() + 1) + "-" + libFunc.getTwoSymbols(date.getDate()) + " " + libFunc.getTwoSymbols(date.getUTCHours()) + ":" + libFunc.getTwoSymbols(date.getUTCMinutes());
  }

  libFunc.getTwoSymbols = function(n){
      return n > 9 ? "" + n: "0" + n;
  }

  libFunc.myEscapeHTML = function(text) {
    return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/(\r\n|\n|\r)/gm, "\\n")
        .replace(/"/g, "\\\"")
        .replace(/'/g, "\'")
        .replace(/;/g, "\\;");
  }

  libFunc.myTextToHTMLText = function(text) {
    return "<p>" + text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/(\r\n|\n|\r)/gm, "</p><p>")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;") + "</p>";
  }
  
  // "экспортировать" libFunc наружу из модуля
  window.MyLib = libFunc;

}());
