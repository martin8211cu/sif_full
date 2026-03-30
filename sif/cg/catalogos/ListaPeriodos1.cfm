<!---CONSULTA PARA EL PLISTAS--->
<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
select 	Speriodo,
		Smes,
		sum(((	 select count (1)  
			from  OficinasxClasificacion o
			where o.CGCperiodo=pp.Speriodo
			    and o.CGCmes=pp.Smes
			    and pp.Ecodigo=#session.ecodigo# ))) as valor

from CGPeriodosProcesados pp 

group by Speriodo,Smes
order by Speriodo desc, Smes desc
</cfquery>

<table width="100%" border="0" cellspacing="6">	
	<!---Consulta sin resultados--->
	<cfif lista.recordcount eq 0>
		<tr>
			<td align="center" bgcolor="CCCCCC">
				<strong>No existen datos en peri&oacute;dos procesados</strong><BR>
			</td>
		</tr>
	</cfif>
	<tr>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="Speriodo,Smes,valor"
			etiquetas="Peri&oacute;do,&nbsp;&nbsp;Mes,Valores Registrados"
			formatos="S,S,S"
			align="left,left,left"
			ira="PorcentajesOficinas.cfm"
			form_method="post"
			showEmptyListMsg="yes"
			keys="Speriodo,Smes"	
			MaxRows="12"
			showLink="yes"
		/>		
	</tr>
</table>
