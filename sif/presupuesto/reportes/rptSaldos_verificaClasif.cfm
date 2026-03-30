<cfquery name="rsCLA" datasource="#Session.DSN#">
	select distinct PCEcodigo, PCEdescripcion, PCCEcodigo, PCCEdescripcion, cubo1.PCEMid, cubo1.PCDCniv, cubo1.PCEcatid, pcec.PCCEclaid
	  from PCDCatalogoCuentaP cubo1
		inner join CPresupuesto c
			 on c.CPcuenta = cubo1.CPcuenta
			and c.Ecodigo = #session.Ecodigo#
		inner join PCECatalogo pce
			 on pce.PCEcatid = cubo1.PCEcatid
		left join PCEClasificacionCatalogo pcec
			inner join PCClasificacionE pcce
				on pcce.PCCEclaid = pcec.PCCEclaid
			 on pcec.PCEcatid = cubo1.PCEcatid
	order by cubo1.PCEMid, cubo1.PCDCniv
</cfquery>

<cfset rsCLA2 = rsCLA>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsCLACAT" dbtype="query">
	select rsCLA.PCEcodigo, rsCLA.PCEdescripcion, 'CLASIFICAR POR: ' #_Cat# rsCLA2.PCCEcodigo #_Cat# ' - ' #_Cat# rsCLA2.PCCEdescripcion as Clasificacion
	  from rsCLA, rsCLA2
	 where rsCLA.PCEMid 	= rsCLA2.PCEMid
	   and rsCLA.PCDCniv 	= rsCLA2.PCDCniv
	   and rsCLA.PCCEclaid	<> rsCLA2.PCCEclaid
	   and rsCLA2.PCCEclaid  is not null
	 order by rsCLA2.PCCEcodigo, rsCLA.PCEcodigo
</cfquery>
<cfif rsCLACAT.recordCount GT 1>
<table width="70%" align="center">
<tr>
	<td align="center">
		<strong style="font-size:14px">CATALOGOS QUE DEBEN SER CLASIFICADOS</strong>
	</td>
</tr>
<tr>
	<td>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
			<cfinvokeargument name="query" value="#rsCLACAT#">
			<cfinvokeargument name="cortes" value="Clasificacion"/>
			<cfinvokeargument name="desplegar" value="PCEcodigo, PCEdescripcion"/>
			<cfinvokeargument name="etiquetas" value="Código, Catálogo"/>
			<cfinvokeargument name="formatos" value="S,S"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="rptSaldos.cfm"/>
			<cfinvokeargument name="showLink" value="FALSE"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="maxrows" value="50"/>
			<cfinvokeargument name="width" value=""/>
			<cfinvokeargument name="pageIndex" value="4"/>
			<cfinvokeargument name="botones" value="Regresar"/>
		</cfinvoke>	
	</td>
</tr>
</table>
</cfif>
