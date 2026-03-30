<cfset filtro = "">
<cfset navegacion = ""> 

<cfif isdefined('form.fFCfechainicio') and len(trim(form.fFCfechainicio)) NEQ 0 and isdefined('form.fFCfechafin') and len(trim(form.fFCfechafin)) NEQ 0 >
	<cfset filtro = #filtro# & " and convert(datetime,a.FCfechainicio,103) between convert(datetime, '" & #form.fFCfechainicio# & "', 103)" & " and convert(datetime, '"& #form.fFCfechafin# & "', 103)">
	<cfset f1 = Form.fFCfechainicio>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fFCfechainicio=" & Form.fFCfechainicio & DE("&") & "fFCfechafin=" & Form.fFCfechafin>
<cfelseif isdefined('form.fFCfechainicio') and len(trim(form.fFCfechainicio)) NEQ 0 and isdefined('form.fFCfechafin') and len(trim(form.fFCfechafin)) EQ 0>	
	<cfset filtro = #filtro# & " and convert(datetime,a.FCfechainicio,103) >= convert(datetime,'" & #form.fFCfechainicio# & "',103)">
	<cfset f1 = Form.fFCfechainicio>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fFCfechainicio=" & Form.fFCfechainicio>
<cfelseif isdefined('form.fFCfechainicio') and len(trim(form.fFCfechainicio)) EQ 0 and isdefined('form.fFCfechafin') and len(trim(form.fFCfechafin)) NEQ 0>	
	<cfset filtro = #filtro# & " and convert(datetime,a.FCfechainicio,103) <= convert(datetime,'" & #form.fFCfechafin# & "',103)">
	<cfset f4 = Form.fFCfechafin>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fFCfechafin=" & Form.fFCfechafin>	
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
<cfif isdefined("form.persona")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "persona=" & Form.persona>						
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "o=3">						
</cfif>					
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>  <cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="FactConceptosAlumno a, Alumnos b, PersonaEducativo c, FacturaConceptos d"/>
				<cfinvokeargument name="columnas" value="convert(varchar, a.FCid) as FCid,
							convert(varchar, a.FCAid) as FCAid,
							a.FCAmontobase,
							convert(varchar, a.Ecodigo) as Ecodigo, 
							convert(varchar, b.persona) as persona, 
							convert(varchar, a.FCfechainicio,103) as FCfechainicio,
							convert(varchar, a.FCfechafin,103) as FCfechafin,
							a.FCAdescuento,
							4 as o,
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
				<cfinvokeargument name="desplegar" value="Nombre, FCdescripcion, FCAperiodicidad, FCfechainicio, FCfechafin, FCAmontores"/>
				<cfinvokeargument name="etiquetas" value="Alumno, Concepto, Periodicidad, Fecha Inicio, Fecha Fin, Resultado "/>
				<cfinvokeargument name="formatos" value="T,T,T,T,T,M"/>
				<cfinvokeargument name="filtro" value=" a.CEcodigo= #Session.Edu.CEcodigo# #filtro#
												  		  and b.persona = #form.persona#
														  and a.Ecodigo = b.Ecodigo 
														  and b.persona = c.persona
														  and a.FCid = d.FCid
													  order by FCfechainicio, Nombre, FCAmontores"/>
				<cfinvokeargument name="align" value="left,Left,Left,Left,Left,right"/>
				<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="maxrows" value="17"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="irA" value="alumno.cfm"/> <!--- Nombre del la forma de Factura de FactConceptosAlumno de Educación --->
				<cfinvokeargument name="formName" value="ListaFactConctos"/>
				<!--- <cfinvokeargument name="incluyeForm" value="false"/> --->
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