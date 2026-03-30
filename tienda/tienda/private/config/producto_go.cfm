<cfparam name="form.Pagina" default="">
<cfparam name="form.id_producto" default="">
<cfparam name="form.id_categoria" default="">
<cfparam name="form.tabnumber" default="">

<cfinclude template="producto_top_go.cfm">
<cfif Len(form.tabnumber) and REFind('^[0-9]$', form.tabnumber) and not IsDefined("form.baja")>
	<cfinclude template="producto_tab#form.tabnumber#_go.cfm">
</cfif>

<cfinclude template="producto_post_go.cfm">

<cflocation url="producto.cfm?id_producto=#URLEncodedFormat(form.id_producto)
							#&Pagina=#URLEncodedFormat(form.Pagina)
							#&id_categoria=#URLEncodedFormat(form.id_categoria)
							#&tabnumber=#URLEncodedFormat(form.tabnumber)#">