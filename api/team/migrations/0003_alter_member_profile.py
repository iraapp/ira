# Generated by Django 4.0.4 on 2022-11-11 19:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('team', '0002_alter_member_profile'),
    ]

    operations = [
        migrations.AlterField(
            model_name='member',
            name='profile',
            field=models.ImageField(upload_to='team'),
        ),
    ]
