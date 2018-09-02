# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.core.files.storage import default_storage

from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db.models.fields.files import FieldFile
from django.views.generic import FormView
from django.views.generic.base import TemplateView
import json

import os;
import requests
from .forms import ContactForm, FilesForm, ContactFormSet


# http://yuji.wordpress.com/2013/01/30/django-form-field-in-initial-data-requires-a-fieldfile-instance/
class FakeField(object):
    storage = default_storage


fieldfile = FieldFile(None, FakeField, "dummy.txt")


class HomePageView(TemplateView):
    template_name = "demo/home.html"

    def get_context_data(self, **kwargs):
        context = super(HomePageView, self).get_context_data(**kwargs)
        # messages.info(self.request, "hello http://example.com")
        return context


class DefaultFormsetView(FormView):
    template_name = "demo/formset.html"
    form_class = ContactFormSet


class DefaultFormView(FormView):
    template_name = "demo/form.html"
    form_class = ContactForm


class DefaultFormByFieldView(FormView):
    template_name = "demo/form_by_field.html"
    form_class = ContactForm


class FormHorizontalView(FormView):
    template_name = "demo/form_horizontal.html"
    form_class = ContactForm


class FormInlineView(FormView):
    template_name = "demo/form_inline.html"
    form_class = ContactForm


class FormWithFilesView(FormView):
    template_name = "demo/form_with_files.html"
    form_class = FilesForm

    def get_context_data(self, **kwargs):
        context = super(FormWithFilesView, self).get_context_data(**kwargs)
        # context["layout"] = self.request.GET.get("layout", "vertical")
        obj = self.request.FILES.get("file")
        baseDir = os.path.dirname(os.path.abspath(__name__));
        jpgdir = os.path.join(baseDir, 'static/upload', '');
        if (obj == None):
            return context

        self.template_name = "demo/form_inline.html"
        filename = os.path.join(jpgdir, obj.name);
        fobj = open(filename, 'wb');
        for chrunk in obj.chunks():
            fobj.write(chrunk);
        fobj.close();
        context['file'] = "exist"
        d = self.get_remote()
        result = json.loads(d)
        context['language'] = result['language']
        context['code_info'] = result['code_info']
        context['match_feature'] = result['match_feature']
        context['type'] = result['type']
        context['md5'] = result['md5']
        return context

    def get_initial(self):
        return {"file": None}

    def get_remote(self):
        # d = requests.get("http://baidu.com")
        d = {
            'status': 1,
            'language': 'php',
            'code_info': 'cat /etc/passwd',
            'match_feature': ['common_webshell24'],
            'type': 'php webshell',
            'md5': '2eeb8bf151221373ee3fd89d58ed4d38'
        }
        return json.dumps(d)


class PaginationView(TemplateView):
    template_name = "demo/pagination.html"

    def get_context_data(self, **kwargs):
        context = super(PaginationView, self).get_context_data(**kwargs)
        lines = []
        for i in range(200):
            lines.append("Line %s" % (i + 1))
        paginator = Paginator(lines, 10)
        page = self.request.GET.get("page")
        try:
            show_lines = paginator.page(page)
        except PageNotAnInteger:
            # If page is not an integer, deliver first page.
            show_lines = paginator.page(1)
        except EmptyPage:
            # If page is out of range (e.g. 9999), deliver last page of results.
            show_lines = paginator.page(paginator.num_pages)
        context["lines"] = show_lines
        return context


class MiscView(TemplateView):
    template_name = "demo/misc.html"
