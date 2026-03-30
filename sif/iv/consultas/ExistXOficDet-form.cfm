<cfset LvarNavegacion = "">
<cfif isdefined("url.Ccodigo") and len(trim(url.Ccodigo)) NEQ 0 and not isdefined("form.Ccodigo")>
	<cfset form.Ccodigo = url.Ccodigo>
</cfif>
<cfif isdefined("url.Aid") and len(trim(url.Aid)) neq 0 and not isdefined("form.Aid")>
	<cfset form.Aid = url.Aid>
</cfif>
<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo)) NEQ 0 and not isdefined("form.Ocodigo")>
	<cfset form.Ocodigo = url.Ocodigo>
</cfif>
<cfif isdefined("url.btnConsultar") and not isdefined("form.btnConsultar")>
	<cfset form.btnConsultar = url.btnConsultar>
</cfif>



<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
	<cfset LvarNavegacion = LvarNavegacion & "Ccodigo=#Form.Ccodigo#">
</cfif>
<cfif isdefined("form.Aid") and len(trim(form.Aid)) neq 0>
	<cfset LvarNavegacion = LvarNavegacion & "&Aid=#Form.Aid#">
</cfif>
<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo)) NEQ 0>
	<cfset LvarNavegacion = LvarNavegacion & "&Ocodigo=#Form.Ocodigo#">
</cfif>
<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
	<cfquery name="rsClasificaciones" datasource="#session.DSN#">
		select Ccodigo, Ccodigoclas, Cdescripcion 
		from Clasificaciones
		where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
	</cfquery>
</cfif>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<script language="javascript1.2" type="text/javascript" >
	function limpiar(valor){
		document.consulta.Aid.value = '';
		document.consulta.Almcodigo.value = '';
		document.consulta.Bdescripcion.value = '';
		document.consulta.Ccodigo.value = '';
		document.consulta.Ccodigoclas.value = '';
		document.consulta.Cdescripcion .value = '';
	}
	function Regresar() {
		location.href='/cfmx/sif/iv/consultas/ExistXOfic.cfm';
		return false;
	}
</script>

<form name="consulta" method="post" action="">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr> 
    	<td colspan="6"><cfinclude template="../../portlets/pNavegacionIV.cfm"></td>
    </tr>
	<tr>
	  <td width="19%">&nbsp;</td>
	   <td width="7%"><div align="right"><strong>Estaci&oacute;n:</strong></div></td>
		<td width="13%">
			<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo)) NEQ 0>
				<cf_sifoficinas form="consulta" id="#form.Ocodigo#">
			<cfelse>
				<cf_sifoficinas form="consulta" Ocodigo="Ocodigo">
			</cfif>							
		</td>
		<td width="15%" nowrap><div align="right"><strong>Tipo Producto</strong></div></td>
		<td width="21%">
          <cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
            <cf_sifclasificacion form="consulta" frame="cli"id="Ccodigo" name="Ccodigoclas" desc="Cdescripcion" query="#rsClasificaciones#">
            <cfelse>
            <cf_sifclasificacion form="consulta" frame="cli" id="Ccodigo" name="Ccodigoclas" desc="Cdescripcion">
          </cfif>
        </td>
		<td width="25%">&nbsp;</td>
	</tr>
	<tr>
	  <td valign="top" nowrap>&nbsp;</td>
	  <td valign="top" nowrap><div align="right"><strong>Almac&eacute;n:</strong></div></td>
	  <td valign="top" nowrap>
        <cfif isdefined("form.Aid") and len(trim(form.Aid)) neq 0>
          <cf_sifalmacen form="consulta" id='#form.Aid#'>
          <cfelse>
          <cf_sifalmacen form="consulta">
        </cfif>
      </td>
	  <td></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
	  <td colspan="6"><div align="center">
	      <input name="btnConsultar" type="submit" value="Consultar">
	      <input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
		  <input name="btnRegresar" type="button" value="Regresar" onClick="javascript: Regresar();">
	      <input name="btnComprar" type="submit" value="Comprar">		
      </div></td>
    </tr>
	<tr>
	  <td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	</table>
</form>	
<table width="100%" cellpadding="2" cellspacing="0">
	<cfif isdefined("btnConsultar") or isdefined("url.PageNum_lista") >
		<tr align="center">
			<td colspan="4">
				<cfquery datasource="#session.dsn#" name="rsExistencias">
						select distinct art.Aid, 
						art.Adescripcion, 
						  (select sum(ex1.Eexistencia) 
						  		  from Articulos art1
								    inner join Existencias ex1
								      on  art1.Aid = ex1.Aid
									inner join Almacen al2
									  on  al2.Ecodigo = ex1.Ecodigo
		  							  and al2.Aid = ex1.Alm_Aid
									<cfif isdefined("form.Aid") and len(trim(form.Aid)) NEQ 0>
										and al2.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
									</cfif> 
									 inner join Clasificaciones cl2
										on cl2.Ccodigo = art1.Ccodigo
										and cl2.Ecodigo = art1.Ecodigo
										<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
											and cl2.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
										</cfif>  
									where art1.Aid     = art.Aid
									  and art1.Ecodigo = art1.Ecodigo    
									
									 ) as Existencias,
									  (select sum(ex1.Eexistmin) 
						  		  from Articulos art1
								    inner join Existencias ex1
								      on  art1.Aid = ex1.Aid
									inner join Almacen al2
									  on  al2.Ecodigo = ex1.Ecodigo
		  							  and al2.Aid = ex1.Alm_Aid
									<cfif isdefined("form.Aid") and len(trim(form.Aid)) NEQ 0>
										and al2.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
									</cfif> 
									 inner join Clasificaciones cl2
										on cl2.Ccodigo = art1.Ccodigo
										and cl2.Ecodigo = art1.Ecodigo
										<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
											and cl2.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
										</cfif>  

									where art1.Aid     = art.Aid
									  and art1.Ecodigo = art1.Ecodigo    
									
									 ) as Minimos,
									  (select sum(ex1.Eexistmax)-sum(ex1.Eexistencia) 
						  		  from Articulos art1
								    inner join Existencias ex1
								      on  art1.Aid = ex1.Aid
									inner join Almacen al2
									  on  al2.Ecodigo = ex1.Ecodigo
		  							  and al2.Aid = ex1.Alm_Aid
									<cfif isdefined("form.Aid") and len(trim(form.Aid)) NEQ 0>
										and al2.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
									</cfif> 
									 inner join Clasificaciones cl2
										on cl2.Ccodigo = art1.Ccodigo
										and cl2.Ecodigo = art1.Ecodigo
										<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
											and cl2.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
										</cfif>  

									where art1.Aid     = art.Aid
									  and art1.Ecodigo = art1.Ecodigo    
									
									 ) as Maximos,
									  (select 
									  round(sum(ex1.Eexistencia)/case sum(ex1.Eexistmax)  when 0 then 1 else sum(ex1.Eexistmax) end * 100,0)
						  		  from Articulos art1
								    inner join Existencias ex1
								      on  art1.Aid = ex1.Aid
									inner join Almacen al2
									  on  al2.Ecodigo = ex1.Ecodigo
		  							  and al2.Aid = ex1.Alm_Aid
									<cfif isdefined("form.Aid") and len(trim(form.Aid)) NEQ 0>
										and al2.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
									</cfif> 
									 inner join Clasificaciones cl2
										on cl2.Ccodigo = art1.Ccodigo
										and cl2.Ecodigo = art1.Ecodigo
										<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
											and cl2.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
										</cfif>  
									where art1.Aid     = art.Aid
									  and art1.Ecodigo = art1.Ecodigo    
									
									 )  as uso,
									  cl.Cdescripcion,
									  art.Ucomprastd as UnidadesPedido,

						(select case when sum(ex1.Eexistencia) <= sum(ex1.Eexistmin) then '&nbsp;<img src=''/cfmx/sif/imagenes/BajoMinimo.gif''  title=''Bajo Minimo'' >' 
							else '&nbsp;<img src=''/cfmx/sif/imagenes/SobreMinimo.gif''  title=''Sobre Minimo'' >' 	end 									  
						  		  from Articulos art1
								    inner join Existencias ex1
								      on  art1.Aid = ex1.Aid
									inner join Almacen al2
									  on  al2.Ecodigo = ex1.Ecodigo
		  							  and al2.Aid = ex1.Alm_Aid
									<cfif isdefined("form.Aid") and len(trim(form.Aid)) NEQ 0>
										and al2.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
									</cfif> 
									 inner join Clasificaciones cl2
										on cl2.Ccodigo = art1.Ccodigo
										and cl2.Ecodigo = art1.Ecodigo
										<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
											and cl2.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
										</cfif>  
									where art1.Aid     = art.Aid
									  and art1.Ecodigo = art1.Ecodigo    
									
									 )  as Estado
									  
						from Articulos art
						  inner join Unidades u
							on  u.Ecodigo = art.Ecodigo
							and u.Ucodigo = art.Ucodigo
						  inner join Clasificaciones cl
						    on cl.Ccodigo = art.Ccodigo
							and cl.Ecodigo = art.Ecodigo
							<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0>
								and cl.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
							</cfif>  
						  
						  inner join Existencias ex
							on art.Aid = ex.Aid

						  inner join Almacen al
							on  al.Ecodigo = ex.Ecodigo
							and al.Aid = ex.Alm_Aid
							<cfif isdefined("form.Aid") and len(trim(form.Aid)) NEQ 0>
								and al.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
							</cfif>  
							
						where art.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  
						
			  </cfquery>
				<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsExistencias#"/>
					<cfinvokeargument name="desplegar" value="Adescripcion, Existencias, Minimos, Maximos, uso, UnidadesPedido, Estado"/>
					<cfinvokeargument name="etiquetas" value="Producto, Existen, Minimo, Capacidad Disponible, % de uso, Unidades de Pedido, Compra"/>
					<cfinvokeargument name="formatos" value="A,M,M,M,M,M,A"/>
					<cfinvokeargument name="align" value="left, right, right, right, right, right, right"/>
					<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
					<cfinvokeargument name="cortes" value="Cdescripcion"/>
					<cfinvokeargument name="irA" value="ExistXOficDet.cfm"/>
					<cfinvokeargument name="checkboxes" value="D"/>
					<cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value=""/>
			  </cfinvoke>
			</td>
			
		</tr>
	</cfif>
</table>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("consulta");
	
	objForm.Ocodigo.required = true;
	objForm.Ocodigo.description="Código de la Estación";

	
	function deshabilitarValidacion(){
		objForm.Ocodigo.required = false;
	
	}
</script> 