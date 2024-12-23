# Руководство пользователя для Voxel Editor

## Введение
Добро пожаловать в **Voxel Editor** — ваш идеальный инструмент для создания и редактирования воксельной графики! С помощью нашего редактора вы можете рисовать вокселями различных цветов и создавать уникальные 3D-объекты.

## Интерфейс

### Тестовая сцена
При запуске Voxel Editor пользователи попадают в тестовую сцену, где могут свободно экспериментировать с функциями редактора или загрузить ранее сохранённые проекты.

### Строка меню
Строка меню содержит следующие разделы:

- **Файл**
  - **Сохранить**: Сохраните текущий проект. Вам будет предложено выбрать папку на компьютере для сохранения файла.
  - **Открыть**: Загрузите существующий проект. Выберите текстовый файл (.txt), который хотите открыть в редакторе.
  - **Выйти**: Закройте редактор.
  
- **Изменить**
  - **Отменить**: Отмените последнее действие (`Ctrl + Z`).
  - **Повторить**: Повторите отмененное действие (`Ctrl + Shift + Z`).
  
- **Помощь**
  - **Руководство**: Откройте это руководство для получения информации о функциях редактора и помощи в работе с ним.

### Панель для выбора цветов
В редакторе имеется палитра для выбора цветов. Вы можете выбрать желаемый цвет и использовать его для рисования вокселей.

## Основные функции

1. **Вставка единичного вокселя**  
   ![](https://github.com/AntoshkA-30I/Voxel-Editor/blob/main/images_for_manual/paint_1.png)  
   **Как использовать**: Выберите инструмент вставки вокселей (активируется из панели инструментов или нажатием `1`) и щелкните `ЛКМ` в области тестовой сцены, чтобы добавить воксель выбранного цвета на уровне высоты, соответствующем вашему первому клику.
   
2. **Рисование вокселями**  
   ![](https://github.com/AntoshkA-30I/Voxel-Editor/blob/main/images_for_manual/paint_2.png)  
   **Как использовать**: Используйте инструмент рисования (активируется из панели инструментов или нажатием `2`) для создания линий и фигур из вокселей. Рисование и стирание вокселей происходит на одном уровне высоты, который определяется первым кликом `ЛКМ` мыши по вокселю.
   
4. **Удаление единичного вокселя**  
   **Как использовать**: Выберите инструмент удаления и щелкните `ПКМ` на воксель, который хотите удалить.
   
5. **Стирание вокселей**  
   ![](https://github.com/AntoshkA-30I/Voxel-Editor/blob/main/images_for_manual/erase_2.png)  
   **Как использовать**: Выберите инструмент стирания (активируется из панели инструментов или нажатием `3`) и проведите курсором по области. Стирание будет происходить на уровне высоты, установленном при первом клике `ЛКМ`, что позволяет удалять несколько вокселей одновременно на одной высоте.
   
6. **Смена цвета существующего вокселя**  
   ![](https://github.com/AntoshkA-30I/Voxel-Editor/blob/main/images_for_manual/repaint.png)  
   **Как использовать**: Выберите инструмент стирания (активируется из панели инструментов или нажатием `4`). Выберите новый цвет из палитры и щелкните `ЛКМ` по вокселю, который хотите изменить.

## Управление камерой

- **Центрирование камеры**  
  ![](https://github.com/AntoshkA-30I/Voxel-Editor/blob/main/images_for_manual/camera.png)  
  **Как использовать**: Используйте функцию центрирования камеры (`Shift + СКМ`), чтобы вернуть камеру в центр координат. Это удобно, если вы потеряли ориентацию в сцене.
  
- **Поворот камеры**  
  **Как использовать**: Камеру можно вращать, удерживая правую кнопку мыши (`СКМ`) и перемещая мышь в нужном направлении. Это позволяет вам изменять угол обзора и лучше рассматривать вашу сцену.
  
- **Перемещение камеры**  
  **Как использовать**: Для перемещения камеры используйте клавиши `W`, `A`, `S`, `D`:  
  - `W` — перемещение вперед  
  - `A` — перемещение влево  
  - `S` — перемещение назад  
  - `D` — перемещение вправо  
  
- **Вертикальное перемещение камеры**  
  **Как использовать**: Для перемещения камеры вверх и вниз используйте клавиши `Q` и `E` соответственно:  
  - `Q` — перемещение вниз  
  - `E` — перемещение вверх  
  
- **Приближение и отдаление камеры**  
  **Как использовать**: Для приближения и отдаления камеры используйте колесо мыши. Прокрутка вперед приближает камеру, а прокрутка назад — отдаляет.

- **Регулировка света на сцене**  
  **Как использовать**: Регулируйте свет на сцене через ползунок в меню или удерживая `Shift + ЛКМ` и перемещая мышь вправо или влево.

## Начало работы

- **Запуск приложения**: При запуске Voxel Editor вы увидите тестовую сцену, где сможете начать рисовать или загрузить старый проект.

- **Создание нового проекта**: Начните новый проект, просто начав рисовать в тестовой сцене. Все изменения можно сохранить в файл.

- **Загрузка существующего проекта**: Для загрузки старого проекта выберите опцию "Открыть" в меню "Файл" и выберите текстовый файл (.txt), который содержит данные вашего воксельного проекта.

## Заключение
Спасибо за использование **Voxel Editor**! Мы надеемся, что это руководство поможет вам быстро освоить основные функции редактора и эффективно работать с ним. Удачи в создании удивительных воксельных проектов!
