# Generated by Django 4.0.4 on 2022-11-11 19:18

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('user_profile', '0001_initial'),
        ('feed', '0006_remove_post_attachments_post_attachments'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='student_profile',
            field=models.ForeignKey(default=9, on_delete=django.db.models.deletion.DO_NOTHING, to='user_profile.student'),
            preserve_default=False,
        ),
    ]
