<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
	
 --->

<cf_tabs width="99%" tabindex="3">
	<cf_tab text="Valores por &Aacute;rea" selected="#form.tab eq 1#">
		<cfinclude template="AreaResponsabilidad-formValores.cfm"> 
	</cf_tab>

	<cf_tab text="Oficinas por &Aacute;rea" selected="#form.tab eq 2#">
		<cfinclude template="AreaResponsabilidad-formOficinas.cfm"> 
	</cf_tab>

	<cf_tab text="Permisos" selected="#form.tab eq 3#">
		<cfinclude template="AreaResponsabilidad-permisos.cfm"> 
	</cf_tab>

</cf_tabs>
