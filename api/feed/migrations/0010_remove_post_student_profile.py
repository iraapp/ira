# Generated by Django 4.0.4 on 2022-12-15 14:40

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('feed', '0009_alter_post_student_profile'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='post',
            name='student_profile',
        ),
    ]
