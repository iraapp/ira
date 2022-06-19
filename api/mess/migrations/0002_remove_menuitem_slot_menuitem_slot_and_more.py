# Generated by Django 4.0.4 on 2022-06-18 15:39

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mess', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='menuitem',
            name='slot',
        ),
        migrations.AddField(
            model_name='menuitem',
            name='slot',
            field=models.ManyToManyField(to='mess.menuslot'),
        ),
        migrations.RemoveField(
            model_name='menuitem',
            name='week_day',
        ),
        migrations.AddField(
            model_name='menuitem',
            name='week_day',
            field=models.ManyToManyField(to='mess.weekday'),
        ),
    ]
