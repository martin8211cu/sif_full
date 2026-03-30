
<cfset filtro = "">
<cfset navegacion = ""> 
<cfif isdefined("Form.fNombreAl") AND #Form.fNombreAl# NEQ "" >
	<cfset filtro = #filtro# &" and upper((c.Pnombre + ' ' + c.Papellido1 + ' ' + c.Papellido2)) like upper('%" & #Form.fNombreAl# & "%')">	
	<cfset f1 = Form.fNombreAl>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fNombreAl=" & Form.fNombreAl>
</cfif>							
<cfif isdefined("Form.fFCid") AND #Form.fFCid# NEQ -1 >
	<cfset filtro = #filtro# &" and a.FCid =" & #Form.fFCid# >	
	<cfset f2 = Form.fFCid>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fFCid=" & Form.fFCid>
</cfif>		 					
<cfif isdefined("Form.fFCAperiodicidad") AND #Form.fFCAperiodicidad# NEQ -1 >
	<cfset filtro = #filtro# &" and a.FCAperiodicidad ='" & #Form.fFCAperiodicidad# & "'">	
	<cfset f3 = Form.fFCAperiodicidad>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fFCAperiodicidad=" & Form.fFCAperiodicidad>
</cfif>		 					
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>  <cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="FactConceptosAlumno a, Alumnos b, PersonaEducativo c, FacturaConceptos d"/>
				<cfinvokeargument name="columnas" value="convert(varchar, a.FCid) as FCid,
							a.FCAmontobase,
							convert(varchar, a.Ecodigo) as Ecodigo, 
							a.FCAdescuento,
							a.FCAmontores,
							case when a.FCAperiodicidad = 'A' then 'Anual' 
								when a.FCAperiodicidad = 'M' then 'Mensual' 
								when a.FCAperiodicidad = 'S' then 'Semestral' 
								when a.FCAperiodicidad = 'T' then 'Trimestral' 								
								when a.FCAperiodicidad = 'B' then 'Bimestral' 
							end as FCAperiodicidad , 
							substring((c.Papellido1 + ' ' + c.Papellido2 + ',' + c.Pnombre),1,60) as Nombre,
							substring(d.FCdescripcion,1,35)  as FCdescripcion
							" />
				<cfinvokeargument name="desplegar" value="Nombre, FCdescripcion, FCAperiodicidad,FCAmontores"/>
				<cfinvokeargument name="etiquetas" value="Alumno, Concepto, Periodicidad ,Resultado "/>
				<cfinvokeargument name="formatos" value="T,T,T,M"/>
				<cfinvokeargument name="filtro" value=" a.CEcodigo= #Session.Edu.CEcodigo# #filtro#
												  		  and a.Ecodigo = b.Ecodigo 
														  and b.persona = c.persona
														  and a.FCid = d.FCid
													  order by Nombre, FCAmontores"/>
				<cfinvokeargument name="align" value="left,Left,Left,right"/>
				<cfinvokeargument name="ajustar" value="N,N,N,N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="irA" value="factConAl.cfm"/> <!--- Nombre del la forma de Factura de FactConceptosAlumno de Educación --->
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
