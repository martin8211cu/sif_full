<!---*******************************************
*******Sistema de Educación*********************
*******Administración de Centros de Estudio*****
*******Plan de Evaluación***********************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<!---*******************************************
*******Registro de Cambios Realizados***********
*******Modificación No:*************************
*******Realizada por:***************************
*******Detalle de la Modificación:**************
********************************************--->
<!---*******************************************
*******Se crea Variable pNavegacion para********
*******obtener variables con datos del proceso**
*******como nombre para utilizarlo en titulos***
*******aquí se crea nav__SPdescripcion**********
********************************************--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!---*******************************************
*******Template: Encabezado y Pie de Pag.*******
********************************************--->
<cf_template template="#session.sitio.template#">
	<!---*******************************************
	*******Templatearea title: Título de Pag.*******
	********************************************--->
	<cf_templatearea name="title">
		<!---*******************************************
		*******Pinta título con vairable generada en****
		*******en include de la navegacion de home******
		********************************************--->
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<!---*******************************************
		*******Portlet Principal************************
		********************************************--->
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<!---NAVEGACION--->
			<cfoutput>#pNavegacion#</cfoutput>
			<!---*******************************************
			*******BREVE DESCRIPCION DE LA PANTALLA********
			*******Esta pantalla consta de dos listas, la superior**
			*******contiene una lista de promociones sin aplicar***
			*******y la inferior contiene una lista de promociones**
			*******aplicadas*********************************
			********************************************--->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<!--- Promociones Sin Aplicar --->
					<cfinclude template="formPromocionProc.cfm">
				<td>
			  </tr>
			  <tr>
			  	<td>
					<!---Promociones Aplicadas --->
					<cfinclude template="formPromocionProcLista.cfm">
				</td>
			  </tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>