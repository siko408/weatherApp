# Generated by Django 2.2.6 on 2020-06-09 20:19

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('weatherChannel', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='comments',
            old_name='bio',
            new_name='comment',
        ),
    ]
