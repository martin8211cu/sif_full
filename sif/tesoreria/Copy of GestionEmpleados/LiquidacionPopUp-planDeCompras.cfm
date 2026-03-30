<cfif isdefined('agregar')>
 	<cfset arr = ListToArray(#form.listaSugerida#, ',', true)>
	<cfset LvarLen = ArrayLen(#arr#)>
	<cfset LvarLineaDet = "#ListGetAt(arr[1],1)#">  <!---Id de la linea de detalle --->	
	 
	<cfquery name="rsLineaDet" datasource="#session.DSN#"> <!----OBTENGO EL ID DE LA TABLA DE PERIODOS SENCILLOS------>
	   Select count(PCGDid) as PCsiGid from PCGDplanCompras where PCGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaDet#">   and Ecodigo = #session.Ecodigo#	 
	</cfquery>
   
	<cfquery name="rsLineaMulti" datasource="#session.DSN#"> <!----OBTENGO EL ID DE LA TABLA DE MULTIPERIODOS------>
	   Select count(PCGDid) as PCsiGid from PCGDplanComprasMultiperiodo where PCGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaDet#"> 
	</cfquery>
	
	<cfinvoke
		component="sif.Componentes.PlanCompras"
		method="GetDetallePlanCompra"
		returnvariable="rsLineaPCMulti">
		<cfinvokeargument name="PCGDid" 	value="#LvarLineaDet#"/>
		<cfinvokeargument name="Ecodigo"	value="#session.Ecodigo#"/>
		<cfinvokeargument name="VerTodo" 	value="S"/>
		<cfinvokeargument name="Fecha"	 	value="#form.GELfecha#"/>
	</cfinvoke>
					
	<cfquery name="rsConceptoGastoEmpleado" datasource="#session.dsn#">
		select GECid,GETid from GEconceptoGasto
			where Cid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.Cid#">
	</cfquery>		
	
	<!---CREA CUENTA FINANCIERA--->		
		<!---Mascara para la cuenta financiera--->	
					
	<cfquery name="rsCFormato" datasource="#session.DSN#">
		select a.CFformato
		from PCGcuentas a							
		where a.PCGcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.PCGcuenta#">
		 and a.Ecodigo = #session.ecodigo#
	</cfquery>								
	<cfset fecha =#form.GELfecha#>
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="rsCta">
		<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
		<cfinvokeargument name="Lprm_CFformato" value="#rsCFormato.CFformato#"/>
		<cfinvokeargument name="Lprm_fecha" value="#fecha#"/>
	</cfinvoke>
	<cfif NOT listfind('OLD,NEW', rsCta)>
		<cfthrow message="#rsCta#">
	</cfif>
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnObtieneCFcuenta" returnvariable="rsCta">
		<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
		<cfinvokeargument name="Lprm_CFformato" value="#rsCFormato.CFformato#"/>
		<cfinvokeargument name="Lprm_fecha" value="#fecha#"/>
	</cfinvoke>
	<cfset LvarCFcuenta = rsCta.CFcuenta>
	 
	<cfoutput>	
		<script language="javascript1.2" type="text/javascript">  	
			window.opener.fnAsignarValores('#rsConceptoGastoEmpleado.GETid#','#rsConceptoGastoEmpleado.GECid#','#LvarCFcuenta#','#rsLineaPCMulti.PCGDid#');
			window.close();
		</script>
	</cfoutput>	
	<cfexit> 
</cfif>


<title>Plan de Compras</title>

<cfif not isdefined ('form.GELid')> 
<cfset form.GELid = url.GELid>
<cfset form.Tipo=url.tipo>	
<cfset form.TipoFil= url.tipo>  
<cfset form.CFid= url.CFid>
<cfset form.CatFil = url.CFid>
<cfset form.GELfecha = url.GELfecha>
</cfif>

	<!---Centros funcionales ---->
	<cfquery name="rsCfunc" datasource="#session.dsn#"> 
		  select a.CFid, a.CFcodigo, a.CFdescripcion
			from CFuncional a
				where
				 a.Ecodigo = #session.Ecodigo#		
				 and a.CFid=<cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.CFid#">
					
	</cfquery>
		
<cfif isdefined ('form.lista')>
  <cfset ids = "">
  <cfset desc = "">
	<cfloop list="#form.CHK#" delimiters="," index="i">		
    	 <cfset lista = ListChangeDelims(i, '',',') >
		 <cfset ids &= ListGetAt(i,7,'|') & ','>
		 <cfset desc&= ListGetAt(i,6,'|') & ','>	 			  
	</cfloop>		
</cfif>
<form action="LiquidacionPopUp-planDeCompras.cfm" method="post" name="form1" onSubmit="javascript: return selecionarTodos();" >
	<table width="100%" border="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td> 			
			<cfif isdefined('form.TipoFil') and len(trim(#form.TipoFil#)) gt 0>
			    <input type="hidden" name="TipoFil" value="<cfoutput>#form.TipoFil#</cfoutput>"/> 
			</cfif>			
			<cfif isdefined('form.CatFil') and len(trim(#form.CatFil#)) gt 0>
			    <input type="hidden" name="CatFil" value="<cfoutput>#form.CatFil#</cfoutput>"/>
			</cfif>	
			<cfif isdefined('form.Tipo') and len(trim(#form.Tipo#)) gt 0>
			    <input type="hidden" name="Tipo" value="<cfoutput>#form.Tipo#</cfoutput>"/> 
			</cfif>			
			<cfif isdefined('form.CFid') and len(trim(#form.CFid#)) gt 0>
			    <input type="hidden" name="CFid" value="<cfoutput>#form.CFid#</cfoutput>"/>
			</cfif>	
			<input type="hidden" name="GELid" value="<cfoutput>#form.GELid#</cfoutput>"/>
			<input type="hidden" name="GELfecha" value="<cfoutput>#form.GELfecha#</cfoutput>"/>
			<tr>
				<td align="center">
					<strong>Centro Funcional:</strong>				
						<cfoutput>#rsCfunc.CFdescripcion#</cfoutput>
				     <strong> Tipo:</strong>							
					   <cfif form.Tipo eq 'S'>
						  <cfoutput>Servicio</cfoutput>
					   </cfif>
				</td>
			</tr>
			<tr>
			<td>&nbsp;</td>
			</tr>			   
				</select>				
			</td>			
		</tr>

				<cfinvoke
					component="sif.Componentes.PlanCompras"
					method="GetDetallePlanCompra"
					returnvariable="rsLineasPlanCompras">
					<cfinvokeargument name="PCGDtipo" 			value="#form.Tipo#"/>
					<cfinvokeargument name="CFid" 				value="#form.CFid#"/>
					<cfinvokeargument name="GEconceptoGasto" 	value="true"/>
					<cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#"/>
					<cfinvokeargument name="VerTodo" 			value="S"/>
					<cfinvokeargument name="Fecha"	 			value="#form.GELfecha#"/>					
					<cfif isdefined('Filtro_PCGDDescripcion') and len(trim(#form.Filtro_PCGDDescripcion#)) gt 0>
						<cfinvokeargument name="Descripcion" 	value="#form.Filtro_PCGDDescripcion#"/>
					</cfif>
					<cfif isdefined('Filtro_CPFormato') and len(trim(#form.Filtro_CPFormato#)) gt 0>
						<cfinvokeargument name="CPFormato" 		value="#form.Filtro_CPFormato#"/>
					</cfif>
				</cfinvoke>
						 
		<cfif rsLineasPlanCompras.recordcount gt 0>
		   <cfset navegacion = rsLineasPlanCompras.PCGDid>
		<cfelse>
		   <cfset navegacion = 1>
		</cfif>
		<tr>			
			<td align="center" width="50%">
				<strong> Lista del Plan de Compras</strong>
			</td>
		</tr>
		<tr>						
			<td align="center"  valign="top">
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLineasPlanCompras#"/>
					<cfinvokeargument name="desplegar" value="PCGDdescripcion, CPFormato, PCGDcantidadTotal, PCGDcantidad, PCGDcantidadCompras, PCGDautorizadoTotal, PCGDautorizado, Disponible,TotalConsumido"/>
					<cfinvokeargument name="etiquetas" value="Descripción, Actividad, Cantidad total, Cantidad del periodo Actual, Cantidad Consumida, Autorizado Total, Autorizado del periodo, Disponible,Consumido"/>
					<cfinvokeargument name="formatos" value="S, S, UM, UM, UM, UM, UM, UM,UM, UM"/>
					<cfinvokeargument name="align" value="left, left,  center, center, center, center, center, center, center, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="key" value="PCGDid" />
					<cfinvokeargument name="irA" value="popUp-planDeCompras.cfm?tipo=#form.Tipo#&CFid=#form.CFid#"/>
					<cfinvokeargument name="showEmptyListMsg" value="false"/>
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="conexion" value="#session.dsn#"/>
					<cfinvokeargument name="usaAJAX" value="yes"/>
					<cfinvokeargument name="funcion" value="fnAsignarLista"/>
					<cfinvokeargument name="fparams" value="PCGDid,PCGDdescripcion, CPFormato,  PCGDcantidadTotal, PCGDcantidad, PCGDcantidadCompras, PCGDautorizadoTotal, PCGDautorizado, TotalConsumido"/>
					<cfinvokeargument name="formname" value="form1"/>
					<cfinvokeargument name="incluyeform" value="false"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>	
				</cfinvoke>
			</td>			
		</tr>			
		<tr>
			<td  align="center">
				<select size="3" name="listaSugerida"  id="listaSugerida">
				</select>
				<label id="msg">No se han selecionado lineas</label>
			</td>						
		</tr>	
		<tr>
	    	<td align="center" height="30px"><input name="agregar" value="Agregar" type="submit" disabled="disabled"/></td>
		</tr>
		<tr>
		  	<td align="center"><strong>* Nota: Para eliminar las líneas seleccionadas, hacer doble clic sobre la línea a eliminar.</strong></td>
		</tr>
	</table>
</form>

<script language="javascript1.2" type="text/javascript">
var soloUno=0;
function fnAsignarLista(id,PCGDdescripcion, CPFormato, PCGDcantidadTotal, PCGDcantidad, PCGDcantidadCompras, PCGDautorizadoTotal, PCGDautorizado, TotalConsumido)
{
	if (soloUno==0 )
	{
		soloUno=1;
	}
	else
	{
		alert ('Solo puede agregar uno a la vez');
		return false;
	}	
	
	
    lista = document.getElementById("listaSugerida");
	for(i = 0; i < lista.length; i++)
	 {
		if(lista.options[i].value == id)
		   return false;	
    }
     	option = document.createElement("option");
		option.value = id;
		option.ondblclick = function(){fnDesasignarLista(this);}
		option.innerHTML = 'Descripción:' +PCGDdescripcion+'  Actividad:' +CPFormato+'     cantidadTotal: '+ PCGDcantidadTotal+'     cantidad: '+ PCGDcantidad +'      cantidadConsumida: '+ PCGDcantidadCompras+'      autorizadoTotal:   '+ PCGDautorizadoTotal+'    autorizado: '+ PCGDautorizado+'     TotalConsumido:  '+ TotalConsumido ;
		lista.appendChild(option);
		fnEdicion(lista);	
}

function fnDesasignarLista(obj)
{
	lista = document.getElementById("listaSugerida");
	lista.removeChild(obj);
	fnEdicion(lista);
	soloUno=0;
}

function selecionarTodos()
{
	lista = document.getElementById("listaSugerida");
	for(i = 0; i < lista.length; i++)
	lista.options[i].selected = "selected";	
}

function fnEdicion(lista)
{
	boton = document.form1.agregar;
	boton.disabled = (lista.length > 0 ? "" : "disabled") ;
	lista.style.display = (lista.length > 0 ? "" : "none") ;
	document.getElementById("msg").style.display = (lista.length > 0 ? "none" : "") ;

}

fnEdicion( document.form1.listaSugerida);
</script>

