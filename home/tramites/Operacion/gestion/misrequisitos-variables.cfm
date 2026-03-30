<!--- 
	Creado por: Ana Villavicencio
	Fecha: 11 de Agosto del 2005
	Motivo: Mostrar lista de datos variables del un requisito repecifico.
 --->

<cfquery name="datorequisito" datasource="#session.tramites.dsn#" >
	select 	dr.id_dato, 
			dr.id_requisito, 
			dr.codigo_dato, 
			dr.nombre_dato, 
			dr.lista_valores, 
			dr.tipo_dato, 
			( select de.valor
			  from TPDatoExpediente de
			  inner join TPExpediente e
			  on e.id_expediente = de.id_expediente
			   and e.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_persona#"> <!--- data esta en gestion-form.cfm --->
			  where de.id_dato=dr.id_dato ) as valor
	from TPDatoRequisito dr
	where dr.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
</cfquery>


<cfset datos_var = ''>
<cfif datorequisito.RecordCount>
	<cfsavecontent variable="datos_var">
		<cfoutput query="datorequisito">
			<cfif listfind(requisitos,  datorequisito.id_requisito) eq 0>
				<cfset requisitos = listappend(requisitos, datorequisito.id_requisito ) >
			</cfif>
		</cfoutput>
	<table width="480" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid black;background-color:#ededed ">
		<cfoutput query="datorequisito">
			<tr>
				<td width="240" nowrap><font style="font-size:10x"><b>#datorequisito.nombre_dato#</b></font></td>
				<td width="240"><font style="font-size:10px"><cfif LEN(TRIM(valor))>#valor#<cfelse> No ha sido definido</cfif></font></td>
			</tr>
		</cfoutput>
	</table>
	</cfsavecontent>
</cfif>
