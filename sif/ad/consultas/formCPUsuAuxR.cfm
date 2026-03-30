<!--********************************--->
<!--***    Diseño: ANDRES LARA   ***--->
<!--***    FECHA: 7/01/2014      ***--->
<!--*******************************---->

<!---ETIQUETAS--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tit" default="Consulta Permiso de Usuarios por Auxiliar" returnvariable="LB_Tit" xmlfile="CPUsuAux.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Clt" default="Cliente" returnvariable="LB_Clt" xmlfile="CPUsuAux.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mdl" default="Módulo"  returnvariable="LB_Mdl" xmlfile="CPUsuAux.xml"/>

<cfinvoke key="LB_Codigo" default="C&oacute;digo "	returnvariable="LB_Codigo"	method="Translate"component="sif.Componentes.Translate" xmlfile="CPUsuAux.xml"/>
<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" method="Translate" component="sif.Componentes.Translate" xmlfile="CPUsuAux.xml"/>
<cfinvoke key="LB_Solicitante" default="Solicitante"	returnvariable="LB_Solicitante"	method="Translate" component="sif.Componentes.Translate"
 xmlfile="CPUsuAux.xml"/>
<cfinvoke key="LB_Aprobador" default="Aprobador"	returnvariable="LB_Aprobador"	method="Translate" component="sif.Componentes.Translate"
  xmlfile="CPUsuAux.xml"/>
<cfinvoke key="LB_MontoMaximo" default="Monto M&aacute;ximo"	returnvariable="LB_MontoMaximo"	method="Translate" component="sif.Componentes.Translate"
xmlfile="CPUsuAux.xml"/>
<cfinvoke key="LB_aAprobar" default="a Aprobar"	returnvariable="LB_aAprobar" method="Translate" component="sif.Componentes.Translate"  xmlfile="CPUsuAux.xml"/>
<cfinvoke key="LB_PuedeCambiar" default="Puede Cambiar"	returnvariable="LB_PuedeCambiar" method="Translate" component="sif.Componentes.Translate"  
xmlfile="CPUsuAux.xml"/>
<cfinvoke key="LB_Tesoreria" default="Tesorer&iacute;a"	returnvariable="LB_Tesoreria" method="Translate" component="sif.Componentes.Translate"  
xmlfile="CPUsuAux.xml"/>

<!--- ******  --->


<!--- URL --->
<cfif isdefined("url.usucodigo") and not isdefined("Form.usucodigo")>
	<cfparam name="Form.usucodigo" default="#url.usucodigo#">
</cfif>
<cfif isdefined("url.modulo") and not isdefined("Form.modulo")>
	<cfparam name="Form.modulo" default="#url.modulo#">
</cfif>
<!--- Los Nombres No Son Requeridos --->
<cfif isdefined("url.empresa") and not isdefined("Form.empresa")>
	<cfparam name="Form.empresa" default="#url.empresa#">
</cfif>
<cfif isdefined("url.nombre") and not isdefined("Form.nombre")>
	<cfparam name="Form.nombre" default="#url.nombre#">
</cfif>

<cf_dbfunction name="date_format"	args="a.Dfecha,DD/MM/YYYY" returnvariable="Dfecha">
<!--- Consulta --->

<!---***** QUERY *****--->
<cfquery name="rsEmpresa" datasource="asp">
    select a.Enombre,a.Ereferencia,b.Ccache
    from Empresa a 
		inner join Caches b
		on a.Cid = b.Cid
    where a.Ereferencia=#Form.empresa#
    order by Enombre
</cfquery>

<cfquery name ="rsCatCaja" datasource="#rsEmpresa.Ccache#">
	select a.CCHdescripcion,a.Usulogin,a.tipo,b.* from
		
		(select a.CCHdescripcion,d.Usulogin,case a.CCHtipo 
				when 1 then 'CAJAS CHICAS PARA COMPRAS MENORES:' 
				when 2 then 'CAJAS ESPECIALES PARA ENTRADA Y SALIDA DE EFECTIVO:' 
				when 3 then 'CAJAS EXTERNAS A GASTO EMPLEADOS:' 
				else 'TIPO DESCONOCIDO:' end as tipo
		from CCHica a
		inner join DatosEmpleado b
		on a.CCHresponsable = b.DEid
		inner join DatosPersonales c
		on c.Pnombre = b.DEnombre and c.Papellido1 = b.DEapellido1 and c.Papellido2 = b.DEapellido2
		inner join Usuario d
		on d.datos_personales = c.datos_personales
            where ltrim(d.Usulogin) = '#Form.usulogin#'
			  and a.Ecodigo = #Form.empresa#) a
	
	right join 

		(select CCHdescripcion as caja
		from CCHica 
		where Ecodigo = #rsEmpresa.Ereferencia#) b	
	on a.CCHdescripcion = b.caja	
	where a.CCHdescripcion <> ''	
</cfquery>
	
<!---***************+++--->

<!--- Usuario --->
<cfquery name="usuarioSel" datasource="#rsEmpresa.Ccache#">
	select DEid 
	from Usuario e 
		inner join DatosPersonales f
          on f.datos_personales = e.datos_personales                   
        inner join DatosEmpleado l
          on f.Pnombre = l.DEnombre and f.Papellido1 = l.DEapellido1 and f.Papellido2 = l.DEapellido2
    where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.usulogin#">
    group by DEid  
</cfquery>

<cfif #usuarioSel.DEid# neq ''>
<cfquery name="RespAct" datasource="#rsEmpresa.Ccache#">
	select DEid
	from AFResponsables
	where Ecodigo = #Form.empresa#
	and DEid = #usuarioSel.DEid#	 
</cfquery>
</cfif>

<cfquery name="UsOPpTes" datasource="#rsEmpresa.Ccache#">
	select tu.TESid, tu.Usucodigo
				, u.Usulogin
				, dp.Pnombre+' '+dp.Papellido1+' '+dp.Papellido2 as Usuario
	from TESusuarioOP tu
			inner join Usuario u
		    inner join DatosPersonales dp
	   on dp.datos_personales = u.datos_personales
       on u.Usucodigo = tu.Usucodigo
		where u.Usulogin = '#Form.usulogin#'
	   order by u.Usulogin  
</cfquery>

<cfquery name="rsListEmp" datasource="#rsEmpresa.Ccache#">
	select tu.CFid, tu.Usucodigo						
			, cf.CFcodigo, cf.CFdescripcion
			, tu.TESUGEsolicitante as Solicitante
			, tu.TESUGEaprobador as Aprobador
			, case 
				when tu.TESUGEaprobador = 1 AND tu.TESUGEmontoMax <> 0 
					then tu.TESUGEmontoMax 
			  end as montoMaximo
			, tu.TESUGEcambiarTES as CambiarTES
	from TESusuarioGE tu
		inner join CFuncional cf
			on cf.CFid = tu.CFid
	where tu.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	  and tu.Ecodigo = #session.Ecodigo#
</cfquery>

<!---Compradores--->
<cfquery name="rsComprador" datasource="#rsEmpresa.Ccache#">
		select 	CMCid, Ecodigo, DEid, CMCnombre, coalesce(CMCjefe,-1) as CMCjefe, CMCdefault, 
				CMCestado, Usucodigo, CMCnivel, CMTStarticulo, CMTSservicio, CMTSactivofijo,CMTSobra, 
				CMCcodigo, Mcodigo, CMCmontomax, CMCautorizador, CMCparticipa, ts_rversion		
		from CMCompradores
		where Ecodigo = #Form.empresa#
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.usucodigo#">
</cfquery>

<cfif rsComprador.recordcount gt 0>	
<cfquery name="rsMcomp" datasource="#rsEmpresa.Ccache#">
		select Mnombre 
		from Monedas 
		where Mcodigo = #rsComprador.Mcodigo#
		and Ecodigo = #Form.empresa#
</cfquery>
</cfif>

<!---Compradores Contratos --->
<cfquery name="rsCompradorCont" datasource="#rsEmpresa.Ccache#">
		select CTCid,Ecodigo,CTCcodigo,CTCnombre,CTCactivo,CTCarticulo,CTCservicio,CTCactivofijo,CTCobra,
			   CTCMcodigo as Mcodigo,CTCmontomax,Usucodigo,BMUsucodigo
		from CTCompradores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.empresa#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.usucodigo#">
</cfquery>

<cfif rsCompradorCont.recordcount gt 0>	
<cfquery name="rsMcompCont" datasource="#rsEmpresa.Ccache#">
		select Mnombre 
		from Monedas 
		where Mcodigo = #rsCompradorCont.Mcodigo#
		and Ecodigo = #Form.empresa#
</cfquery>
</cfif>

<!--- Solicitantes ---->
<cfquery name="rsSolicitante" datasource="#rsEmpresa.Ccache#">
	select CMSid, coalesce(DEid,0) as DEid, CMSestado, Usucodigo, CMScodigo, coalesce(CFid,-1) as CFid, ts_rversion
	from CMSolicitantes
	where Ecodigo = #Form.empresa#
	  and CMScodigo = '#Form.usulogin#'
</cfquery>

<cfif rsSolicitante.recordcount gt 0>

<cfquery name="rsCFuncional" datasource="#session.DSN#">
	select a.CFid, a.CFcodigo, a.CFdescripcion
	from CFuncional a
		inner join CMSolicitantesCF b
			on b.CFid = a.CFid
			and b.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitante.CMSid#">
	where Ecodigo=#Form.empresa#		
</cfquery>
<!---cfquery name="rsCFuncional" datasource="#rsEmpresa.Ccache#">
	select CFid, CFcodigo, CFdescripcion
	from CFuncional
	where Ecodigo=#Form.empresa#
	  and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitante.CFid#">
</cfquery---->
</cfif>
<!---PRESUPUESTO--->

<cfquery name="rsCFUsuario" datasource="#rsEmpresa.Ccache#">
	select a.CPSUidOrigen, a.CPSUid, a.Ecodigo, a.CFid as CFpk, a.Usucodigo, a.CPSUconsultar, a.CPSUtraslados, a.CPSUreservas,
	 a.CPSUformulacion, a.CPSUaprobacion, a.CPSUidOrigen, a.ts_rversion, 
			' ' as ts, b.CFcodigo, b.CFdescripcion
	from CPSeguridadUsuario a inner join CFuncional b on a.CFid = b.CFid and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = #Form.empresa#
	and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.usucodigo#">
		order by coalesce(a.CPSUidOrigen, a.CPSUid), coalesce(a.CPSUidOrigen, -1), b.CFcodigo
</cfquery>

<!---INVENTARIOS --->
<cfquery name="rsAlmacen" datasource="#rsEmpresa.Ccache#">
	select ar.Aid, ar.Usucodigo, ar.Ulocalizacion,u.Usulogin,a.Bdescripcion,a.Almcodigo,
			(d.Papellido1 +' ' + d.Papellido2 +' ' + d.Pnombre) as NombreCompleto
	from Usuario u
		inner join DatosPersonales d
			on u.datos_personales = d.datos_personales
		inner join AResponsables ar
			on  u.Usucodigo = ar.Usucodigo
		inner join Almacen a
			on ar.Aid = a.Aid	
				and ar.Ocodigo = a.Ocodigo
				and ar.Ecodigo = a.Ecodigo
	where ar.Ecodigo = #Form.empresa#
		and u.Usulogin = '#Form.usulogin#'
	order by d.Papellido1, d.Papellido2, d.Pnombre
</cfquery>
<!---TESORERIA --->
<cfquery name="rsListaCFXSolicitud" datasource="#rsEmpresa.Ccache#">
				select 
					  tu.CFid, tu.Usucodigo, cf.CFcodigo, cf.CFdescripcion, 
					  tu.TESUSPsolicitante  as Solicitante, 
					  tu.TESUSPaprobador as Aprobador 
					  , case 
						when tu.TESUSPaprobador = 1 AND tu.TESUSPmontoMax <> 0 
							then tu.TESUSPmontoMax 
					  end as montoMaximo, 
					  tu.TESUSPcambiarTES as CambiarTES
				from TESusuarioSP tu
					inner join CFuncional cf
						on cf.CFid = tu.CFid
				where tu.Usucodigo = #Form.usucodigo#
				  and tu.Ecodigo = #Form.empresa#
</cfquery>
<!------- FIN DE LOS QUERYS -------->

<style type="text/css">
	.style0 {text-align: center; text-transform: uppercase; font-size: 16px; text-shadow: Black; font-weight: bold; }
	.style1 {text-align: center; text-transform: uppercase; font-size: 14px; text-shadow: Black; font-weight: bold; }
	.style2 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style3 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style4 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black;}
</style>
<br>
<cfoutput>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="">
		<tr>
			<td class="style0">#Session.Enombre#</td>
		</tr>
		<tr>
			<td class="style1">#LB_Tit#</td>
		</tr>
		<tr>
			<td class="style2">#LB_Clt#: #Form.nombre#</td>
		</tr>
		<tr>
			<td class="style3">#LB_Mdl#: #Form.modulo#</td>
		</tr>
	</table>

<br>
	
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
<!---Comprador Contratos---->
<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Contratos' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS') and #rsCompradorCont.recordcount# gt 0>

	  <tr>  	  
	    <td class="tituloListas" coldspan="1">#LB_Mdl#: Contratos/Compradores Contratos</td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  		<!--- Detalle --->
	  <tr>
	  	<td>	
	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		
		  			
		  	    <form>
		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    </tr>
		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    	  <td width="5%" align="left"><strong>C&oacute;digo:</strong>&nbsp;  	 
		  	    	  	#rsCompradorCont.CTCcodigo#		  	    	 
		  	    	  <td width="5%" align="left">		  	    	  	
		  	    	  	<strong>Moneda:</strong>
		  	    	  	#rsMcompCont.Mnombre#
		  	    	  </td>
		  	    	  <td width="5%" align="right">
		  	    	  	<strong>Monto M&aacute;ximo:</strong>
		  	    	  	#LSCurrencyFormat(rsCompradorCont.CTCmontomax,'none')#
		  	    	  </td>
		  	    	  <td width="20%">&nbsp;</td>		  	    	  
		  	    </tr>

		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    </tr>
		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    </tr>

		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    	<td colspan = "4">
        		<fieldset style="width:95%"><legend><strong>&nbsp;Tipos de Compra permitidos para el comprador&nbsp;</strong></legend>
        		<table width="100%" cellpadding="2" cellspacing="0" border="0" >
          			<tr>
            			<td>
              				<cfif rsCompradorCont.CTCarticulo EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
              				<strong>&nbsp;Art&iacute;culo</strong>
						</td>
            			<td>
              				<cfif rsCompradorCont.CTCactivofijo EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
              				<strong>&nbsp;Activo Fijo</strong>
						</td>
            			<td>
              				<cfif rsCompradorCont.CTCservicio EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
              				<strong>&nbsp;Servicio</strong>
						</td>
							<td>
              				<cfif rsCompradorCont.CTCobra EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
              				<strong>&nbsp;Obra</strong>
						</td>
          			</tr>
          		</table>
          		</fieldset>
          		</td>
          		</tr>
		  	   </form> 
		  	    	<tr><td>&nbsp;</td></tr>  		
	  	</table>
	  </td>
	  </tr>
</cfif>


<!---SECCION DE COMPRAS ---->
  	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Compras' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS') and #rsComprador.recordcount# gt 0>
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="1">#LB_Mdl#: Compras/CM-Compradores</td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  		<!--- Detalle --->
	  <tr>
	  	<td>	
	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		
		  			
		  	    <form>
		  	    <tr>		  	    			  	    		  	    
		  	    	  <td width="1%">&nbsp;</td>
		  	    	  <td width="5%" align="center">
		  	    	  	 <cfif #rsComprador.CMCdefault# EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
		  	    	  	<strong>&nbsp;Comprador Default</strong>
		  	    	  </td>	  	    	  
		  	    	  <td width="5%" align="center">
		  	    	  	<cfif #rsComprador.CMCestado# EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
		  	    	  	<strong>&nbsp;Comprador Default</strong>
		  	    	  </td>
		  	    	  <td width="5%" align="center">
		  	    	  	<cfif #rsComprador.CMCautorizador# EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
		  	    	  	<strong>&nbsp;Es autorizador</strong>
		  	    	  </td>
		  	    	  <td width="10%">
		  	    	  	<cfif #rsComprador.CMCparticipa# EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
		  	    	  	<strong>&nbsp;Participa en asignaci&oacute;n de cargas de trabajo</strong>
		  	    	  </td>
		  	    </tr>
		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    </tr>
		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    	  <td width="5%" align="right"><strong>C&oacute;digo:</strong>&nbsp;  	 
		  	    	  	#rsComprador.CMCcodigo#		  	    	 
		  	    	  <td width="5%" align="center">		  	    	  	
		  	    	  	<strong>Moneda:</strong>
		  	    	  	#rsMcomp.Mnombre#
		  	    	  </td>
		  	    	  <td width="5%" align="right">
		  	    	  	<strong>Monto M&aacute;ximo:</strong>
		  	    	  	#LSCurrencyFormat(rsComprador.CMCmontomax,'none')#
		  	    	  </td>		  	    	  
		  	    </tr>

		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    </tr>
		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    </tr>

		  	    <tr>
		  	    	<td width="1%">&nbsp;</td>
		  	    	<td colspan = "4">
        		<fieldset style="width:95%"><legend><strong>&nbsp;Tipos de Compra permitidos en registro de Ordenes de Compra&nbsp;</strong></legend>
        		<table width="100%" cellpadding="2" cellspacing="0" border="0" >
          			<tr>
            			<td>
              				<cfif rsComprador.CMTStarticulo EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
              				<strong>&nbsp;Art&iacute;culo</strong>
						</td>
            			<td>
              				<cfif rsComprador.CMTSactivofijo EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
              				<strong>&nbsp;Activo Fijo</strong>
						</td>
            			<td>
              				<cfif rsComprador.CMTSservicio EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
              				<strong>&nbsp;Servicio</strong>
						</td>
							<td>
              				<cfif rsComprador.CMTSobra EQ "1"><strong>X</strong><cfelse><strong>-</strong></cfif>
              				<strong>&nbsp;Obra</strong>
						</td>
          			</tr>
          		</table>
          		</fieldset>
          		</td>
          		</tr>
		  	   </form> 
		  	    	<tr><td>&nbsp;</td></tr>  		
	  	</table>
	  </td>
	  </tr>
  	</cfif>


  	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Compras' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS') and rsSolicitante.recordcount gt 0>
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="1">#LB_Mdl#: Compras/CM-Solicitantes </td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  		<!--- Detalle --->  
	  	<td>	
	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		

		  		<td style="1px solid black;" width="2%"><strong>&nbsp;</strong></td> 		
		  	    <form>		  	    			  	    		  	    		  	    	  
		  	    	  <td>
		  	    	  <strong>Solicitante Activo:</strong>&nbsp;	
		  	    	  <cfif rsSolicitante.CMSestado eq 1><strong>SI</strong><cfelse><strong>NO</strong></cfif>	 		  	    	  		  	    	  	  	
		  	   </form> 
		<tr><td>&nbsp;</td></tr>
    	
    	<tr>
    		<td>&nbsp;</td>
    		<td class="listaPar" style="border-bottom:1px solid Blackk;" width="1%"><strong>Codigo</strong></td>
    		<td class="listaPar" style="border-bottom:1px solid Blackk;" width="10%"><strong>Centro Funcional</strong></td>
    		<td width="20%">&nbsp;</td>
    	</tr> 	
    <cfloop query="rsCFuncional">    	    	
    	<tr>
    		<td>&nbsp;</td>
    		<td class="listaNon">#CFcodigo#</td>
    		<td class="listaNon">#CFdescripcion#</td>
    	</tr>
    </cfloop>	
    		<tr><td>&nbsp;</td></tr>
	  	</table>
	  	</td>	  
  	</cfif>

<!--- SECCION PRESUPUESTO --->

	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Presupuesto' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS') AND rsCFUsuario.recordcount gt 0 >
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="1">#LB_Mdl#: Presupuesto/PRES-Seguridad por Usuario </td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  		<!--- Detalle --->  
	  	<td>	
	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		

		  		<td style="1px solid black;" width="2%"><strong>&nbsp;</strong></td> 				  	    		  	    			  	    		  	      
		  	    <tr>
				    <td>&nbsp;</td>
					<td class="titulolistas">Centro Funcional&nbsp;</td>
				    <td class="titulolistas" align="center">Consultar&nbsp;</td>
				    <td class="titulolistas" align="center">Trasladar&nbsp;</td>
				    <td class="titulolistas" align="center">Provisionar&nbsp;</td>
				    <td class="titulolistas" align="center">Formular&nbsp;</td>
				    <td class="titulolistas" align="center">APROBAR<BR>TRASLADOS&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			<form>	
			<cfloop query="rsCFUsuario">												
				<tr>
					<td></td>
					<td nowrap>#rsCFUsuario.CFcodigo# - #rsCFUsuario.CFdescripcion#</td>
					<td align="center"><cfif #rsCFUsuario.CPSUconsultar#><strong>X</strong><cfelse><strong>-</strong></cfif></td>
					<td align="center"><cfif #rsCFUsuario.CPSUtraslados#><strong>X</strong><cfelse><strong>-</strong></cfif></td>
					<td align="center"><cfif #rsCFUsuario.CPSUreservas#><strong>X</strong><cfelse><strong>-</strong></cfif></td>
					<td align="center"><cfif #rsCFUsuario.CPSUformulacion#><strong>X</strong><cfelse><strong>-</strong></cfif></td>
					<td align="center"><cfif #rsCFUsuario.CPSUaprobacion#><strong>X</strong><cfelse><strong>-</strong></cfif></td>
				</tr>			
			</cfloop>			  	    
			</form>
    		<tr><td>&nbsp;</td></tr>
	  	</table>
	  	</td>	  
  	</cfif>

<!--- SECCION TESORERIA --->
  	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Tesoreria' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS') and #rsCatCaja.recordcount# gt 0>
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="1">#LB_Mdl#: Tesoreria/Apertura de Cajas</td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  <!--- Detalle --->
	  <tr>
	  	<td>	
	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		

		  		<td style="1px solid black;" width="5%"><strong>&nbsp;</strong></td> 		
		  	   	<td style="1px solid black; ">
		  	   		<strong>Cajas Asignadas:</strong>
		  	    </td>
		  	    <form>
		  	    <cfloop query="rsCatCaja">
		  	    	<tr>
		  	    	  <td>&nbsp;</td>
		  	    	  <td>&nbsp;</td>		  	    		  	    
		  	    	  <td>&nbsp;</td>
		  	    	  <td>
		  	    	  	<cfif #rsCatCaja.CCHdescripcion# neq ''>
		  	    	  		<strong>X</strong><cfelse><strong>-</strong> 	  		  
		  	    	  	</cfif> 
		  	    	  &nbsp;#rsCatCaja.caja#</td>
		  	        </tr>	  	        
		  	    </cfloop>
		  	   </form> 
		  	    	<tr><td>&nbsp;</td></tr>  		
	  	</table>
	  </td>
	  </tr>
  	</cfif>

<!--- SECCION INVENTARIO --->
  	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Inventario' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS') and #rsAlmacen.recordcount# gt 0>
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="1">#LB_Mdl#: Inventario/Almacenes</td>  	    
	  </tr>	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  <!--- Detalle --->
	  <tr>
	  	<td>	
	  	<table width="100%">
			<tr>

		  		<td width="10%" style="1px solid black; "><strong>&nbsp;</strong></td>
		  	   	<td width="1%" nowrap="nowrap" align="left" style="border-bottom: 1px solid black;	padding-bottom: 5px;">
					<strong>Lista de Almacenes asociados al Usuario</strong>
				</td>
				<td>&nbsp;</td>
			</tr>	
		</table>		
	  </td>
	  </tr>
	  <tr>
	  	<td>
	  		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	  	<tr>
		  	<td width="11%" height="17" nowrap="" align="left">&nbsp;</td>   	  
		  	<td class="tituloListas" width="8%" valign="bottom" align="left">C&oacute;digo</td>
		  	<td class="tituloListas" width="8%"valign="bottom" align="left">Almac&eacute;n</td>
		  	<td width="65%" height="17" nowrap="" align="left">&nbsp;</td> 		  	
		</tr>
	  	<cfloop query="rsAlmacen">
		  		  
		  <tr>
		  	<td width="18" height="17" nowrap="" align="left">&nbsp;</td>   
		  	<td align="left">#rsAlmacen.Bdescripcion#</td>		  	
		  	<td align="left">#rsAlmacen.Almcodigo#</td>		  	
		  </tr>
		  
		  </cfloop>

	  		</table> 			  										
		
	  	</td>	
	  </tr>		
  	</cfif>

<!---MANTENIMIENTO A EMPLEADOS--->  	
	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Activo Fijo' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS')>
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="1">#LB_Mdl#: Activo Fijo/Mantenimiento a Empleados</td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  		<!--- Detalle --->  
	  	<td>	
	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		

		  		<td style="1px solid black;" width="10%"><strong>&nbsp;</strong></td> 		
		  	    <form>		  	    			  	    		  	    
		  	    	  <td width="10%">&nbsp;</td>
		  	    	  <td>
		  	    	  Empleado:&nbsp;	
		  	    	  	<cfif usuarioSel.recordcount gt 0 AND #RespAct.DEid# neq ''>
		  	    	  		<strong>SI</strong>		  	    	  		  	    	  		
		  	    	  	<cfelse>
		  	    	  		<strong>NO</strong>
		  	    	  	</cfif> 
		  	    	  </td>
		  	    	  
		  	    	  <td>&nbsp;</td>
		  	    	  <td>
		  	    	  	Responsable de Activo Fijo:&nbsp;
		  	    	  	<cfif usuarioSel.recordcount gt 0 AND #RespAct.DEid# neq ''>
		  	    	  		<strong>SI</strong>	
		  	    	  	<cfelse>
		  	    	  		<strong>NO</strong>	
		  	    	  	</cfif> 
		  	    	  </td>		  	        	        
		  	   </form> 
		  	    	<tr><td>&nbsp;</td></tr>  		
	  	</table>
	  	</td>	  
</cfif>

  	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Tesoreria' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS')>
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="1">#LB_Mdl#: Tesoreria/Usuarios de Ordenes de Pago por Tesorería</td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  		<!--- Detalle --->  
	  	<td>	
	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		

		  		<td style="1px solid black;" width="10%"><strong>&nbsp;</strong></td> 		
		  	    <form>		  	    			  	    		  	    
		  	    	  <td width="10%">&nbsp;</td>		  	    	  	  	    	  
		  	    	  <td>
		  	    	  	Puede Hacer Ordenes de Pago:&nbsp;
		  	    	  	<cfif #UsOPpTes.recordcount# gt 0>
		  	    	  		<strong>SI</strong><cfelse><strong>NO</strong>	  	    	  		  
		  	    	  	</cfif> 
		  	    	  </td>		  	        	        
		  	   </form> 
		  	    	<tr><td>&nbsp;</td></tr>  		
	  	</table>
	  	</td>	  
  	</cfif>

  	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Tesoreria' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS') and rsListaCFXSolicitud.recordcount gt 0>
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="6">#LB_Mdl#: Tesoreria/Usuarios de Solicitudes de Pago por Empresa</td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  <!--- Detalle --->
  	  <tr>
  		<td>

	  	<table width="100%">
			<tr>
		  		<td width="1%" style="1px solid black; "><strong>&nbsp;</strong></td>
		  	   	<td width="1%" nowrap="nowrap" align="left" style="border-bottom: 1px solid black;	padding-bottom: 5px;">
					<strong>Lista de Centros Funcionales del Usuario</strong>
				</td>
				<td>&nbsp;</td>
			</tr>	
		</table>	

	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		
	  											
		<tr>

		  <td class="tituloListas" width="18" height="17" nowrap="" align="left">&nbsp;</td>   	
		  <td class="tituloListas" valign="bottom" align="left">
			<strong> Código</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="left">
			<strong> Centro Funcional</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="center">
			<strong> Solicitante</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="center">
		    <strong> Aprobador</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="right">
		    <strong>Monto Máximo<br>a Aprobar</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="center">
			<strong>Puede Cambiar<br>Tesorería</strong>
		  </td>
		  </tr>

		<form>
		  <cfloop query="rsListaCFXSolicitud">
		  		  
		  <tr>
		  	<td width="18" height="17" nowrap="" align="left">&nbsp;</td>   
		  	<td align="left">#CFcodigo#</td>
		  	<td>#CFdescripcion#</td>
		  	<td align="center">
		  	  <cfif #Solicitante# eq 1 >
		  		<strong>X</strong><cfelse><strong>-</strong>	
		  	  </cfif>
		    </td>
		  	<td align="center">
		  	  <cfif #Aprobador# eq 1 >
		  		<strong>X</strong><cfelse><strong>-</strong>
		  	  </cfif>
		    </td>
		  	<td align="right">#MontoMaximo#</td>
		  	<td align="center">
		  	  <cfif #CambiarTES# eq 1 >
		  		<strong>X</strong><cfelse><strong>-</strong>
		  	  </cfif>
		    </td>	
		  </tr>
		  
		  </cfloop>
			</form>	
		  <tr><td>&nbsp;</td></tr>
		  	</table>
		    </td>
		  </tr>

  	</cfif> <!---Fin del if--->

  	<cfif (ltrim(rtrim(#Form.modulo#)) eq 'Tesoreria' or ltrim(rtrim(#Form.modulo#)) eq 'TODOS') and rsListEmp.recordcount gt 0>
	  
	  <tr>  	  
	    <td class="tituloListas" coldspan="6">#LB_Mdl#: Tesoreria/Usuarios de Solicitudes de Gastos de Empleado</td>  	    
	  </tr>
	  
	  <tr>
		<td style="border-top: 1px solid black;" align="left" colspan="6" nowrap >&nbsp;</td>
  	  </tr>
  <!--- Detalle --->
  	  <tr>
  		<td>

	  	<table width="100%">
			<tr>
		  		<td width="1%" style="1px solid black; "><strong>&nbsp;</strong></td>
		  	   	<td width="1%" nowrap="nowrap" align="left" style="border-bottom: 1px solid black;	padding-bottom: 5px;">
					<strong>Lista de Centros Funcionales del Usuario</strong>
				</td>
				<td>&nbsp;</td>
			</tr>	
		</table>	

	  	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"> 		
	  										
		<tr>

		  <td class="tituloListas" width="18" height="17" nowrap="" align="left">&nbsp;</td>   	
		  <td class="tituloListas" valign="bottom" align="left">
			<strong> Código</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="left">
			<strong> Centro Funcional</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="center">
			<strong> Solicitante</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="center">
		    <strong> Aprobador</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="right">
		    <strong>Monto Máximo<br>a Aprobar</strong>
		  </td>
		  <td class="tituloListas" valign="bottom" align="center">
			<strong>Puede Cambiar<br>Tesorería</strong>
		  </td>
		  </tr>

		<form>
		  <cfloop query="rsListEmp">
		  		  
		  <tr>
		  	<td width="18" height="17" nowrap="" align="left">&nbsp;</td>   
		  	<td align="left">#rsListEmp.CFcodigo#</td>
		  	<td>#rsListEmp.CFdescripcion#</td>
		  	<td align="center">
		  	  <cfif #rsListEmp.Solicitante# eq 1 >
		  		<strong>X</strong><cfelse><strong>-</strong>	
		  	  </cfif>
		    </td>
		  	<td align="center">
		  	  <cfif #rsListEmp.Aprobador# eq 1 >
		  		<strong>X</strong><cfelse><strong>-</strong>
		  	  </cfif>
		    </td>
		  	<td align="right">#rsListEmp.MontoMaximo#</td>
		  	<td align="center">
		  	  <cfif #rsListEmp.CambiarTES# eq 1 >
		  		<strong>X</strong><cfelse><strong>-</strong>
		  	  </cfif>
		    </td>	
		  </tr>
		  
		  </cfloop>
			</form>	
			<tr><td>&nbsp;</td></tr>
		  	</table>
		    </td>
		  </tr>	
  	</cfif> <!---Fin del if--->  	

</table>
</cfoutput>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td class="style4"> ------------------ Fin del Reporte ------------------ </td>
	</tr>
</table>
