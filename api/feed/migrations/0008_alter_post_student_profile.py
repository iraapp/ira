# Generated by Django 4.0.4 on 2022-12-15 14:07

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('user_profile', '0001_initial'),
        ('feed', '0007_post_student_profile'),
    ]

    operations = [
        migrations.AlterField(
            model_name='post',
            name='student_profile',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='user_profile.student'),
        ),
    ]
