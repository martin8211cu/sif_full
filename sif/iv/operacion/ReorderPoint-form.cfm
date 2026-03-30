<cfif Isdefined('Update')>
	<cfquery datasource="#session.dsn#">     
    UPDATE INVDreorden
       SET Cantidad    = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Cantidad#">,
           BMUsucodigo = #session.Usucodigo#
     WHERE INVDRid     = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#INVDRid#"> 
     </cfquery>
     <cfabort>
</cfif>

<!---►►Actividad Empresarial (N-No se usa AE, S-Se usa Actividad Empresarial)◄◄--->
<cfquery name="rsActividad" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'N') as Pvalor 
  	from Parametros 
   where Pcodigo = 2200 
     and Mcodigo = 'CG'
     and Ecodigo = #session.Ecodigo# 
</cfquery>
<cfif not rsActividad.RecordCount>
	<cfset rsActividad.Pvalor = 'N'>
</cfif>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfif Isdefined('btnGenerar')>
	<cftransaction>
        <cfquery name="rsReorden" datasource="#session.dsn#">
           DELETE FROM INVDreorden where INVRid in (select INVRid from INVreorden where Usucodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Session.Usucodigo#">)
        </cfquery>
        <cfquery datasource="#session.dsn#">     
        	DELETE FROM INVreorden WHERE Usucodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Session.Usucodigo#"> 
        </cfquery>
        <cfquery name="rsInsert" datasource="#session.dsn#">     
        	INSERT INTO INVreorden (Usucodigo,BMUsucodigo)
            VALUES(
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#session.Usucodigo#">,
                   #session.Usucodigo#
            		) 
            <cf_dbidentity1 name="rsInsert" datasource="#session.dsn#"> 
         </cfquery> 
         	<cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnvariable="LvarINVRid">
         <cfquery name="rsInsert" datasource="#session.dsn#">    
         	INSERT INTO INVDreorden (INVRid,Aid,Art_Aid,Cantidad,BMUsucodigo)
  			select 
  				<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#LvarINVRid#">,
                 al.Aid,
                 art.Aid,
                 art.Ucomprastd,
           		 #session.Usucodigo#
            from Articulos art
            
             inner join Existencias ex
                on art.Aid = ex.Aid
            
            inner join Almacen al
                 on al.Ecodigo = ex.Ecodigo
                and al.Aid     = ex.Alm_Aid
                
            inner join Clasificaciones cl
                 on cl.Ccodigo = art.Ccodigo
                and cl.Ecodigo = art.Ecodigo
            
            where art.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            <cfif LEN(TRIM(AlmcodigoIni))>
            	and al.Almcodigo > = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#AlmcodigoIni#">
			</cfif>
            <cfif LEN(TRIM(AlmcodigoFin))>
             	and al.Almcodigo < = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#AlmcodigoFin#">
			</cfif>
            <cfif LEN(TRIM(CcodigoclasIni))>
            	and cl.Ccodigoclas > = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#CcodigoclasIni#">
			</cfif>
            <cfif LEN(TRIM(CcodigoclasFin))>
             	and cl.Ccodigoclas < = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#CcodigoclasFin#">
			</cfif>
             <cfif NivelU EQ 'B'>
             	and ex.Eexistencia <= ex.Eexistmin
             <cfelseif  NivelU EQ 'S'>
             	and ex.Eexistencia > ex.Eexistmin
			</cfif>
     	</cfquery> 
    </cftransaction>
<cfelse>
	<cfquery name="rsReorden" datasource="#session.dsn#">
    	select INVRid from INVreorden where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
    </cfquery>
	<cfset LvarINVRid = rsReorden.INVRid>
</cfif>

	<cf_dbfunction name="to_char"	args="DR.Cantidad"  returnvariable="CantidadChar">
    <cf_dbfunction name="to_char"	args="DR.INVDRid"   returnvariable="INVDRidChar">
    
	<cfquery datasource="#session.dsn#" name="rsPuntoReorden">
        select DR.INVDRid, ex.Eexistmin, '<div style="color:##03C">' #_Cat# upper(al.Bdescripcion)#_Cat# '</div>' Bdescripcion, cl.Cdescripcion, art.Acodigo, art.Adescripcion, ex.Eexistencia, art.Ucomprastd, 
      
        '<input onkeyup = "_CFinputText_onKeyUp(this,event,5,0,false);" name="Cantidad_" value="'#_Cat# #CantidadChar# #_Cat#'" onchange="ModificaCant('#_Cat# #INVDRidChar# #_Cat#',this.value)" />' as Cantidad
        from INVreorden ER
            inner join INVDreorden DR
                on ER.INVRid = DR.INVRid
            inner join Almacen al
                on DR.Aid = al.Aid
            inner join Articulos art
                on art.Aid = DR.Art_Aid
            inner join Clasificaciones cl
                on cl.Ccodigo = art.Ccodigo
               and cl.Ecodigo = art.Ecodigo 
             inner join Existencias ex
                on ex.Aid     = art.Aid
               and ex.Alm_Aid = al.Aid
        where ER.INVRid = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarINVRid#">
        order by al.Bdescripcion, cl.Cdescripcion
	</cfquery>

<script>
!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
</script>
<script>
$(document).ready(function(){
	$("#CancelarSC").click(function(event){
	  event.preventDefault();
	  $("#capaefectos").hide("slow");
	  $("#GenSC").hide("slow");
	  $("#CancelarSC").hide("slow");
	  $("#PreparaSC").show(1000);
	  
	});
 
	$("#PreparaSC").click(function(event){
	  event.preventDefault();
	   $("#capaefectos").show(1000);
	   $("#GenSC").show(1000);
	   $("#CancelarSC").show(1000);
	   $("#PreparaSC").hide("slow");
	});
});
</script>


<form action="ReorderPoint-sql.cfm" method="post" name="form1" onsubmit="return valida()">
	<div align="center" style="color:#F00">
    	<cfif isdefined('session.compras.Solicitante') and LEN(TRIM(session.compras.Solicitante))>
       		<cfif rsPuntoReorden.recordCount>
				<cfset solicitante = session.compras.Solicitante >
                <cfset url.SC_INV  = true>
                <cfset MODO 	   = 'ALTA'> 
                <div id="capaefectos" style="background-color: #CCC; padding:10px; display:none">
                    <cfinclude template="/sif/cm/operacion/solicitudesE-form.cfm">
                    <cfif rsActividad.Pvalor eq 'S'>
                    	<cf_ActividadEmpresa etiqueta="Actvidad Empresarial">	
                    </cfif>
                </div>
                <input name="INVRid"	  id="INVRid" 	  value="<cfoutput>#LvarINVRid#</cfoutput>" type="hidden" />
                <input name="CancelarSC"  id="CancelarSC" value="Cancelar" 						class="btnNormal" type="button" style="display:none"/>
                <input name="PreparaSC"   id="PreparaSC"  value="Preparar Solicitud de Compra"  class="btnNormal" type="button"/>
                <input name="GenSC"  	  id="GenSC" 	  value="Generar Solicitud de Compra"   class="btnNormal" type="submit" style="display:none" onclick="return confirm('Esta seguro que desea generar la solicitudes de Compra de Inventario?');"/>
      		</cfif>
        <cfelse>
        	No tienen permisos para generar Solicitudes de Compra
      	</cfif>
        <input name="BtnVolver"	  id="BtnVolver" type="button" 	  value="Elegir Nuevos Filtros" class="btnAnterior" onclick="window.location ='/cfmx/sif/iv/operacion/ReorderPoint.cfm'";/>
    </div>
</form>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
    <cfinvokeargument name="query" 				value="#rsPuntoReorden#"/>
    <cfinvokeargument name="desplegar"	 		value="Acodigo,Adescripcion,Eexistencia,Eexistmin,Ucomprastd,Cantidad"/>
    <cfinvokeargument name="etiquetas" 			value="Codigo,Articulo,Existencias,Cant. Minima, Cant. Sugerida,Cant. Pedido"/>
    <cfinvokeargument name="formatos" 			value="S,S,S,S,S,S"/>
    <cfinvokeargument name="align" 				value="left, left,left, left, left, left"/>
    <cfinvokeargument name="ajustar" 			value="N,N,N,N,N,N"/>
    <cfinvokeargument name="cortes" 			value="Bdescripcion,Cdescripcion"/>
    <cfinvokeargument name="irA" 				value="ExistXOficDet.cfm"/>
    <cfinvokeargument name="checkboxes" 		value="N"/>
    <cfinvokeargument name="navegacion" 		value="#Navegacion#"/>
    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
    <cfinvokeargument name="keys" 				value="INVDRid"/>
    <cfinvokeargument name="showLink" 			value="false"/>
    <cfinvokeargument name="UsaAjax" 			value="true"/>
    <cfinvokeargument name="Conexion" 			value="#session.dsn#"/>
</cfinvoke>
<script>
	function ModificaCant(INVDRid,Cantida){
	  document.getElementById('ifrCambioVal').src = 'ReorderPoint-form.cfm?Update=true&INVDRid='+INVDRid+'&Cantidad='+Cantida;
    }
	function valida(){	
		var error   = false;
		var mensaje = "Se presentaron los siguientes errores:\n";
		
		if ( trim(document.form1.CFid.value) == '' ){
			error = true;
			mensaje += " - El campo Centro Funcional es requerido.\n";
		}
		if ( trim(document.form1.CMTScodigo.value) == '' ){
			error = true;
			mensaje += " - El campo Tipo Solicitud es requerido.\n";
		}
		if ( trim(document.form1.ESobservacion.value) == '' ){
			error = true;
			mensaje += " - El campo Descripción es requerido.\n";
		}
		if ( document.form1.CMTScompradirecta.value == 1 ){
			if ( trim(document.form1.SNcodigo.value) == '' ){
				error = true;
				mensaje += " - El campo Proveedor es requerido.\n";
			}
		}
		if ( trim(document.form1.Mcodigo.value) == '' ){
			error = true;
			mensaje += " - El campo Moneda es requerido.\n";
		}
		if ( trim(document.form1.EStipocambio.value) == '' ){
			error = true;
			mensaje += " - El campo Tipo de Cambio es requerido.\n";
		}
		if (error){
			alert(mensaje);
			return false;
		}
		else{
			document.form1.CMTScodigo.disabled 			= false;
			document.form1.EStipocambio.disabled 		= false;
			return true;
		  }
	}
</script>