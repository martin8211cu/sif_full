<cfset filtro = "">
<cfset navegacion = ""> 
<cfif isdefined("Form.fNombreAl") AND #Form.fNombreAl# NEQ "" >
	<cfset filtro = #filtro# &" and upper((c.Pnombre + ' ' + c.Papellido1 + ' ' + c.Papellido2)) like upper('%" & #Form.fNombreAl# & "%')">	
	<cfset f1 = Form.fNombreAl>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fNombreAl=" & Form.fNombreAl>
</cfif>							
<cfif isdefined("Form.fIdescripcion") AND #Form.fIdescripcion# NEQ "" >
	<cfset filtro = #filtro# &" and upper((a.Idescripcion)) like upper('%" & #Form.fIdescripcion# & "%')">	
	<cfset f2 = Form.fIdescripcion>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fIdescripcion=" & Form.fIdescripcion>
</cfif>	
<cfif isdefined("Form.fITid") AND #Form.fITid# NEQ -1 >
	<cfset filtro = #filtro# &" and a.ITid= " & #Form.fITid# >	
	<cfset f4 = Form.fITid>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fITid=" & Form.fITid>
</cfif>							
<cfif isdefined("Form.fIfecha") AND #Form.fIfecha# NEQ "">
	<cfset filtro = #filtro# & " and convert(datetime,a.Ifecha,103) between convert(datetime, '" & #form.fIfecha# & "', 103)" & " and convert(datetime, '"& #form.fIfecha# & "', 103)">
	<cfset f3 = Form.fIfecha>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fIfecha=" & Form.fIfecha>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>  <cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="Incidencias a, Alumnos b, PersonaEducativo c, IncidenciasTipo d"/>
				<cfinvokeargument name="columnas" value="convert(varchar, a.Iid) as Iid,
							substring(a.Idescripcion,1,35) as Idescripcion, 
							substring(d.ITdescripcion,1,35) as ITdescripcion,
							convert(varchar,d.ITid) as ITid,
							a.Imonto,
							a.Ifecha,
							convert(varchar, a.Ecodigo) as Ecodigo, 
							substring((c.Papellido1 + ' ' + c.Papellido2 + ',' + c.Pnombre),1,35) as Nombre
							" />
				<cfinvokeargument name="desplegar" value="Nombre, Ifecha, ITdescripcion, Idescripcion, Imonto"/>
				<cfinvokeargument name="etiquetas" value="Alumno, Fecha, Tipo, Descripción, Monto "/>
				<cfinvokeargument name="formatos" value="T,D,T,T,M"/>
				<cfinvokeargument name="filtro" value=" a.CEcodigo= #Session.Edu.CEcodigo# #filtro#
												  		  and a.Ecodigo = b.Ecodigo 
														  and b.persona = c.persona
														  and a.ITid    = d.ITid
													  order by Nombre, a.Idescripcion"/>
				<cfinvokeargument name="align" value="left,left,left,left,right"/>
				<cfinvokeargument name="ajustar" value="N,N,S,N,N"/>
				<cfinvokeargument name="maxrows" value="17"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="irA" value="factIncidencias.cfm"/> <!--- Nombre del la forma de Factura de Incidencias de Educación --->
			</cfinvoke>
	

			</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
