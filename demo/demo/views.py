# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.core.files.storage import default_storage

from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.db.models.fields.files import FieldFile
from django.views.generic import FormView
from django.views.generic.base import View
from django.views.generic.base import TemplateView
from utils import transfer_to_json_format
from utils import get_local_time
import json

import os;
import requests
from .forms import ContactForm, FilesForm, ContactFormSet


LOCAL_SERVER_DOMAIN = "http://127.0.0.1:5003/Scan"
RESULT_FILE = "static/result/result.txt"
baseDir = os.path.dirname(os.path.abspath(__name__))

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

    http_method_item = ['language', 'code_info', 'match_feature', 'type', 'md5', 'file_name']

    def get_context_data(self, **kwargs):
        context = super(FormInlineView, self).get_context_data(**kwargs)
        jpgdir = os.path.join(baseDir, RESULT_FILE)
        context["ret"] = []
        try:
            fobj = open(jpgdir, 'r+')
            data = fobj.read().splitlines()
            if (data != None and len(data) != 0):
                ret = []
                for item in data[::-1][:10]:
                    ret.append(json.loads(item))
                context["ret"] = ret
            return context
        except IOError:
            return context


class FormWithFilesView(FormView):
    template_name = "demo/form_with_files.html"
    form_class = FilesForm

    def get_context_data(self, **kwargs):
        context = super(FormWithFilesView, self).get_context_data(**kwargs)
        return context
        # context["layout"] = self.request.GET.get("layout", "vertical")
        obj = self.request.FILES.get("file")
        if (obj == None):
            return context
        baseDir = os.path.dirname(os.path.abspath(__name__));
        jpgdir = os.path.join(baseDir, 'static/upload', '');
        # // save file
        filename = os.path.join(jpgdir, obj.name);
        fobj = open(filename, 'wb+');
        for chrunk in obj.chunks():
            fobj.write(chrunk);
        fobj.close();
        # response
        self.emit(obj.name)

        context["file"] = obj
        return context

    def get_initial(self):
        return {"file": None}

    def emit(self, file_name):
        baseDir = os.path.dirname(os.path.abspath(__name__));
        jpgdir = os.path.join(baseDir, 'static/upload/'+file_name, '');
        kwargs = {
            "path": jpgdir
        }
        # resp = requests.get(LOCAL_SERVER_DOMAIN, **kwargs)
        resp = '{"status": 1, "language": "php", "code_info": "cat /etc/passwd", "match_feature": ["common_webshell24"], "type": "php webshell", "md5": "2eeb8bf151221373ee3fd89d58ed4d38"}'
        try:
            d = transfer_to_json_format(resp)
        except ValueError:
            raise ValueError
        # add filename
        d['file_name'] = file_name
        self.save_result(d)

    def save_result(self, d):
        d['time'] = get_local_time()
        # save file result
        jpgdir = os.path.join(baseDir, RESULT_FILE)
        fobj = open(jpgdir, 'a+')
        fobj.write(json.dumps(d) + '\n')
        fobj.close()


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
