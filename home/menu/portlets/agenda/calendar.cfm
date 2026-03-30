<!---
	Portlet de calendario para la agenda.
	El clic en una fecha te lleva a la agenda de este día
--->
<form action="/cfmx/home/menu/portlets/agenda/agenda.cfm" name="calform">
	<cf_calendario form="calform" includeForm="no" name="fecha" fontSize="10" onChange="document.getElementById('pendientes').src='/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha='+escape(dmy)">
</form>
