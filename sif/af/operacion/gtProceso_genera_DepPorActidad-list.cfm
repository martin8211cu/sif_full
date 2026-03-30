<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>
<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value"/>
<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux"     returnvariable="rsMes.value"/>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char" args="a.ADTPlinea" 			returnvariable="ADTPlinea">
<cf_dbfunction name="to_char" args="a.TAmeses"   			returnvariable="unidades">
<cf_dbfunction name="to_char" args="a.TAmeses"   			returnvariable="unidades">
<cf_dbfunction name="to_char" args="afs.AFSsaldovutiladq"   returnvariable="AFSsaldovutiladq">
<cf_dbfunction name="to_char" args="c.Avalrescate"   		returnvariable="Avalrescate">
<cf_dbfunction name="to_char" args="c.Aid"   				returnvariable="Aid">
<cf_dbfunction name="to_char_currency" args="a.TAmontolocadq"   		returnvariable="TAmontolocadq">
<cf_dbfunction name="to_char_currency" args="a.TAmontolocmej"   		returnvariable="TAmontolocmej">
<cf_dbfunction name="to_char_currency" args="a.TAmontolocrev"   		returnvariable="TAmontolocrev">

<cfsavecontent variable="INPunidad">
	<cf_monto name="Linea_AAAA" value="111.00" onblur="modificar(AAAA, this.value,AFSsaldovutiladq,Avalrescate,Aid);" size = "10" decimales = "0">Ucodigo
</cfsavecontent>
<cfsavecontent variable="INPdepAdq">
	<cf_monto name="DepAdq_AAAA" value="111.0000" size = "10" decimales = "4" style="border:none; background-color:inherit" readonly="true">
</cfsavecontent>
<cfsavecontent variable="INPdepMej">
	<cf_monto name="DepMej_AAAA" value="111.0000" size = "10" decimales = "4" style="border:none; background-color:inherit" readonly="true">
</cfsavecontent>
<cfsavecontent variable="INPdepRev">
	<cf_monto name="DepRev_AAAA" value="111.0000" size = "10" decimales = "4" style="border:none; background-color:inherit" readonly="true">
</cfsavecontent>


<cfset INPunidad	= replace(INPunidad,"'","''","ALL")>
<cfset INPdepAdq	= replace(INPdepAdq,"'","''","ALL")>
<cfset INPdepMej	= replace(INPdepMej,"'","''","ALL")>
<cfset INPdepRev	= replace(INPdepRev,"'","''","ALL")>

<cfset INPunidad	= replace(INPunidad,"AAAA","' #_Cat# #ADTPlinea#  #_Cat# '","ALL")>
<cfset INPdepAdq	= replace(INPdepAdq,"AAAA","' #_Cat# #ADTPlinea#  #_Cat# '","ALL")>
<cfset INPdepMej	= replace(INPdepMej,"AAAA","' #_Cat# #ADTPlinea#  #_Cat# '","ALL")>
<cfset INPdepRev	= replace(INPdepRev,"AAAA","' #_Cat# #ADTPlinea#  #_Cat# '","ALL")>

<cfset INPunidad	= replace(INPunidad,"111.00","' #_Cat# #unidades#      #_Cat# '","ALL")>
<cfset INPdepAdq	= replace(INPdepAdq,"111.0000","' #_Cat# #TAmontolocadq# #_Cat# '","ALL")>
<cfset INPdepMej	= replace(INPdepMej,"111.0000","' #_Cat# #TAmontolocmej# #_Cat# '","ALL")>
<cfset INPdepRev	= replace(INPdepRev,"111.0000","' #_Cat# #TAmontolocrev# #_Cat# '","ALL")>

<cfset INPunidad	= replace(INPunidad,"AFSsaldovutiladq","' #_Cat# #AFSsaldovutiladq#  #_Cat# '","ALL")>
<cfset INPunidad	= replace(INPunidad,"Avalrescate","' #_Cat# #Avalrescate#  #_Cat# '","ALL")>
<cfset INPunidad	= replace(INPunidad,"Aid","' #_Cat# #Aid#  #_Cat# '","ALL")>
<cfset INPunidad	= replace(INPunidad,"Ucodigo","' #_Cat# Coalesce(d.Ucodigo,'-No Definido-')  #_Cat# '","ALL")>
		
<cfset Columnas= "'#PreserveSingleQuotes(INPunidad)#' as INPunidad,
				  '#PreserveSingleQuotes(INPdepAdq)#' as INPdepAdq,
				  '#PreserveSingleQuotes(INPdepMej)#' as INPdepMej,
				  '#PreserveSingleQuotes(INPdepRev)#' as INPdepRev,
				  d.Ucodigo,
				 a.ADTPlinea, a.Ecodigo, a.AGTPid, 
				 a.Aid, a.IDtrans, a.TAmeses,
				 a.TAperiodo as Periodo, a.TAfalta, '  ' as espacio, 
				 c.Adescripcion as Activo, c.Aplaca, c.Aserie, 
				 d.ACdescripcion as Categoria,
				 e.ACdescripcion as Clase,
				 ((select min(g.Odescripcion) from Oficinas g where g.Ecodigo = f.Ecodigo and g.Ocodigo = f.Ocodigo)) as Oficina,
				 ((select min(h.Ddescripcion) from Departamentos h where h.Ecodigo = f.Ecodigo and h.Dcodigo = f.Dcodigo)) as Departamento,
				 f.CFdescripcion as CentroF,AFSsaldovutiladq,Avalrescate,
				 afs.AFSvaladq - afs.AFSdepacumadq as ValorLibrosAdq, 
				 afs.AFSvalrev - afs.AFSdepacumrev as ValorLibrosRev, 
				 afs.AFSvalmej - afs.AFSdepacummej as ValorLibrosMej, 
				 a.TAmontolocadq, a.TAmontolocrev, a.TAmontolocmej,
				 (afs.AFSvaladq + afs.AFSvalrev + afs.AFSvalmej) - (afs.AFSdepacumadq + afs.AFSdepacumrev + afs.AFSdepacummej + a.TAmontolocadq + a.TAmontolocrev + a.TAmontolocmej) as valorLibros">
		 
<cfset Tabla= "ADTProceso a 
				inner join AGTProceso b 
					on b.AGTPid = a.AGTPid 
				   and b.IDtrans = a.IDtrans 
				   and b.Ecodigo = a.Ecodigo 
				inner join AFSaldos afs 
					on afs.Aid = a.Aid 
				   and afs.AFSperiodo = #rsPeriodo.value#  
				   and afs.AFSmes = #rsMes.value#
				inner join CFuncional f 
					on f.CFid = a.CFid
				inner join Activos c
					inner join ACategoria d 
					 	on d.ACcodigo = c.ACcodigo 
					   and d.Ecodigo = c.Ecodigo
					inner join AClasificacion e 
						on e.ACid = c.ACid 
					   and e.ACcodigo = c.ACcodigo 
					   and e.Ecodigo = c.Ecodigo
				 on c.Aid = a.Aid">				 
			
<cfset desplegar  = "ValorLibrosAdq,ValorLibrosMej,ValorLibrosRev,TAmontolocadq,TAmontolocmej,TAmontolocrev,valorLibros">
<cfset Etiqueta   = "Placa, Activo,Unidades, Valor Anterior Adquisición, Valor Anterior Mejoras, Valor Anterior Revaluación, Depreciación Adquisición, Depreciación Mejoras, Depreciación Revaluación, Valor Libros,">
<cfset Filtro     = "a.IDtrans=4 and a.AGTPid=#URL.AGTPid#">
<cfset navegacion = "&IDtrans=4&AGTPid=#URL.AGTPid#">
<table width="100%" border="0">
  <tr>
    <td>&nbsp;</td>
    <td>	 
	<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
		<cfinvokeargument name="columnas" 		value="#Columnas#"/>
		<cfinvokeargument name="tabla" 			value="#Tabla#"/>
		<cfinvokeargument name="filtro" 		value="#Filtro# order by CentroF, Categoria, Clase, Aplaca, Adescripcion"/>
		<cfinvokeargument name="cortes" 		value="CentroF, Categoria, Clase"/>
		<cfinvokeargument name="desplegar" 		value="Aplaca, Activo, INPunidad,ValorLibrosAdq,ValorLibrosMej,ValorLibrosRev,INPdepAdq,INPdepMej,INPdepRev,valorLibros, espacio"/>
		<cfinvokeargument name="etiquetas" 		value="#Etiqueta#"/>
		<cfinvokeargument name="formatos" 		value="V,V,V,M,M,M,V,V,V,M,M,M"/>
		<cfinvokeargument name="align" 			value="left,left,left,right,right,right,right,right,right,right,center,left"/>
		<cfinvokeargument name="ajustar" 		value="N"/>
		<cfinvokeargument name="irA" 			value="##"/>
		<cfinvokeargument name="formname" 		value="fadtproceso"/>
		<cfinvokeargument name="navegacion"	 	value="#navegacion#"/>	
		<cfinvokeargument name="showLink" 		value="false"/>	
		<cfinvokeargument name="FontSize" 		value="9"/>
		<cfinvokeargument name="MaxRowsQuery" 	value="500"/>
	</cfinvoke>
	</td>
    <td>&nbsp;
	</td>
  </tr>
  <tr><td colspan="3" align="center">
  	<input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript: location.href='agtProceso_DEPRECIACION<cfoutput>#LvarPar#</cfoutput>.cfm'"/>
  </td></tr>
</table>
<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="10" frameborder="1" height="0" width="0" scrolling="auto"></iframe>
<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		function modificar(ADTPlinea, value,AFSsaldovutiladq,Avalrescate,Aid){
			if (value != "")
			{
				var param= 'valor='+qf(value)+'&ADTPlinea='+ADTPlinea+'&AFSsaldovutiladq='+AFSsaldovutiladq+'&Avalrescate='+Avalrescate+'&Aid='+Aid;
				document.getElementById('ifrCambioVal').src = 'gtProceso_genera_DepPorActidad-frame.cfm?'+param;
			}
		}
	</script>
</cfoutput>