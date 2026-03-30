<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" returnvariable="CPPfechaDesde">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" returnvariable="CPPfechaHasta">
<cfquery datasource="#session.DSN#" name="periodo">
	select CPPid, case a.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
			#_Cat# ' de ' #_Cat# 
		   case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
				#_Cat# ' a ' #_Cat# 
			case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
			as Pdescripcion
		from CPresupuestoPeriodo a
		where Ecodigo = #Session.Ecodigo#
		  and CPPid   = #form.CPPid#
</cfquery>
		
<style type="text/css">
	.msgError {font-family: Georgia, "Times New Roman", Times, serif;font-style: italic;font-weight: bold;color: #FF0000;}
</style>
<cfset NavegacionD ="">
<cfset botonesExtra ="Calcular_Precios">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="b.Aid"            returnvariable="Aid">
<cf_dbfunction name="to_char"	args="a.FPPAPrecio" returnvariable="FPPAPrecio">
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset decimales = LvarOBJ_PrecioU.getDecimales()>
<cfsavecontent variable="INP">
	<cf_inputNumber name="Articulo_AAAA" value="999" onblur="modificar(AAAA, this.value);" enteros = "#17-decimales#" decimales = "#decimales#">
</cfsavecontent>
	<cfset INP	= replace(INP,"'","''","ALL")>
	<cfset INP	= replace(INP,"AAAA","' #_Cat# #Aid#  #_Cat# '","ALL")>
	<cfset INP	= replace(INP,"999","' #_Cat# #FPPAPrecio#  #_Cat# '","ALL")>
	<cfquery datasource="#session.DSN#" name="ArticulosNuevos">
		select count(1) cantidad 
			from Articulos a 
		where Ecodigo = #session.Ecodigo# 
		  and (select count(1) 
					from FPPreciosArticulo b 
			   where b.Aid = a.Aid 
				 and a.Ecodigo = b.Ecodigo 
				 and b.CPPid   = #form.CPPid#) = 0
 	</cfquery>
		<table border="0" width="100%">
			<tr><td align="center"><cfoutput><strong>Periodo #periodo.Pdescripcion#</strong></cfoutput></td></tr>
		</table>
	<cfif ArticulosNuevos.cantidad GT 0 >
		<cfset botonesExtra &=",Cargar_Articulos">
		<table border="0" width="100%">
			<tr><td align="center"><span class="msgError">Existen <cfoutput>#ArticulosNuevos.cantidad#</cfoutput> artículos nuevos que no han sido agregados, pulse cargar artículos para agregarlos.</span></td></tr>
		</table>
	</cfif>
	<cfquery datasource="#session.DSN#" name="listadoArticulos">
		select b.Aid,b.Acodigo, b.Adescripcion, '#PreserveSingleQuotes(INP)#' as FPPAPrecio  
		from FPPreciosArticulo a
			inner join Articulos b
				on a.Aid = b.Aid
		where a.Ecodigo = #session.Ecodigo#
		  and a.CPPid   = #form.CPPid#
		<cfif isdefined('form.filtro_Acodigo') and len(trim(form.filtro_Acodigo))>
		  and upper(b.Acodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.filtro_Acodigo)#%">
		</cfif>
		<cfif isdefined('form.filtro_Adescripcion') and len(trim(form.filtro_Adescripcion))>
		  and upper(b.Adescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.filtro_Adescripcion)#%">
		 </cfif>
		order by b.Acodigo, b.Adescripcion
	</cfquery>
<br />
<form name="form1" action="EstimacionPrecio.cfm?CPPid=#form.CPPid#" method="post">
	<input name="CPPid" type="hidden" value="<cfoutput>#form.CPPid#</cfoutput>"/>
	<table align="center" border="0" cellpadding="0" cellspacing="0"><tr>
		<td><strong>Código Articulo:</strong>&nbsp;</td>
		<td><input name="filtro_Acodigo" type="text" value="<cfif isdefined('form.filtro_Acodigo')><cfoutput>#form.filtro_Acodigo#</cfoutput></cfif>"></td>
		<td>&nbsp;</td>
		<td><strong>Descripción Articulo:</strong>&nbsp;</td>
		<td><input name="filtro_Adescripcion" type="text" size="50" value="<cfif isdefined('form.filtro_Adescripcion')><cfoutput>#form.filtro_Adescripcion#</cfoutput></cfif>"></td>
		<td><input name="filtrar" type="submit" value="Filtrar" class="btnFiltrar"/></td>
	</tr></table>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
		query			="#listadoArticulos#"
		desplegar		="Acodigo,Adescripcion,FPPAPrecio"
		etiquetas		="Codigo, Articulo, Precio"
		formatos		="S,S,S"
		align			="left,left,right"
		showlink		="no" 
		incluyeform		="no"
		showEmptyListMsg="yes"
		keys			="Aid"
		maxrows			="15"
		navegacion		="#NavegacionD#"
		botones         ="Regresar,#botonesExtra#"
		usaAJAX			= "true"
		conexion 		= "#session.DSN#"	
		PageIndex 		= "3"
	/>
</form>
<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>	
<script language="javascript">
	function modificar(Aid, value){
		if (value != "")
		{
			document.getElementById('ifrCambioVal').src='EstimacionPrecio-sql.cfm?value='+qf(value)+'&Aid='+Aid+'&CPPid='+<cfoutput>#form.CPPid#</cfoutput>+'&btnModificar=true';
		}
		else
		document.getElementById('Articulo_'+Aid).value = '0.00';
	}
	function funcCargar_Articulos()
	{
		 <cfoutput>document.location.href = 'EstimacionPrecio-sql.cfm?CPPid=#form.CPPid#&btnCargar_Articulos=true'</cfoutput>;
		return false;
	}
	function funcCalcular_Precios()
	{
		if(confirm('¿Esta seguro que desea Actualizar todos los precios, con el precio promedio de inventarios?'))
		 <cfoutput>document.location.href = 'EstimacionPrecio-sql.cfm?CPPid=#form.CPPid#&btnCalcular_Precios=true'</cfoutput>;
		return false;
	}

</script>