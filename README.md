**IRA (Institute App)**

![id_logo1](https://user-images.githubusercontent.com/106883815/172019930-dc6b8390-17e7-430d-beda-70c585c290bf.png)


There has been need to develop the institute app for the internal purpose and ease of information sharing. Institute is evolving in many activities and Building glory with smooth academic and industry collaboration via hosting various conferences, seminars, and much more. Various in-house chapters are also involved in different activities. Institute is also performing best in placements and students are creating success stories. Additionally, there is a pressing need of documenting rules and regulations and ensuring the on-ground follow-up of the same. To share information and various stories there is a need to develop the app.


**Technologies Used:**
1. Flutter https://flutter.dev/
2. Django https://www.djangoproject.com/

**Installation:**
1. Clone this repository locally
```
git clone https://github.com/iraapp/institute_app.git
```
2. Create your own virtual environment and use pip to install depedencies.
```sh
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

3. Install flutter dependencies
```
// Move into app folder
flutter pub get
```

4. One time backend setup
```
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
```

5. Run backend using:
```
python manage.py runserver
```

6. Run frontend using:
```
flutter run -t lib/main_dev.dart
```

7. Setup pre commit hook
```
./setup_hooks.sh
```

**Codebase Infrastructure**

The backend code mainly resides in the `api` folder and the frontend code resides in the `app` folder.

The backend uses google cloud platform for using Google OAuth. You need to get API key from google for using this functionality.

There are three flavours for the flutter app.
  - dev: This uses local development server for running the app. Mainly intended for use with emulator.
  - staging: This can use any test/prod server for running the app. Mainly intended for testing with a physical device.
  - prod: This uses the final production server. No intended for testing purpose.


**Cloud Architecture**


![IRA DevOps drawio (1)](https://github.com/iraapp/ira/assets/106883815/047a8b3d-3856-4ac6-91e1-71003975a7f5)


**Demo**

https://github.com/iraapp/ira/assets/106883815/1e12885a-b917-40db-a4e8-2f3b3a82a046
