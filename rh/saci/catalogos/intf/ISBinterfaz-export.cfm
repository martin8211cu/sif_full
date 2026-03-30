<cfset form.ds = session.dsn>
<cfset form.dbms = 'syb'>
<cfset form.tabla = 'ISBinterfaz'>
<cfset form.maxrows = -1>
<cfset form.where = ''>
<cfset form.identity = 0>
<cfset form.pk = 'interfaz'>

<cfinclude template="/asp/admin/exportar/datos-apply.cfm">