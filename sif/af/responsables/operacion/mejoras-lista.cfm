<!--- me muestra una lista de usuarios en donde aparecen 
	  mi usuario y la lista de los usuarios
	  que pertenenece al centro de custodia que tengo acargo		
 --->

<!--- Consulta de Usuarios para el combo del filtro de la lista ---><strong></strong>
<cfquery name="rsUsuarios" datasource="#Session.Dsn#">
	select U.Usucodigo,U.Usulogin  , 2 as indice
	 from Usuario U
	   inner join CRCCUsuarios UC
		  on U.Usucodigo = UC.Usucodigo
		where U.Usucodigo !=  #session.Usucodigo#
				 and UC.CRCCid in (Select b.CRCCid
						    from UsuarioReferencia  a
							 inner join CRCentroCustodia b
							   on a.llave =  <cf_dbfunction name="to_char" args="b.DEid">
							  and b.Ecodigo = #Session.Ecodigo# <!---ecodigo normal --->
									where STabla = 'DatosEmpleado'
									and a.Usucodigo   =  #session.Usucodigo#   <!---codigo  de mi usuario--->
									and a.Ecodigo     =  #Session.ecodigosdc#) <!--- ecodigosdc--->

	union
	select   #session.Usucodigo# as Usucodigo, 
		 	 '#session.Usulogin#'  as  Usulogin, 
			 1 as indice
		from dual
	order by 3,2	
</cfquery>
<cfif rsUsuarios.recordcount gt 0>
	<cfset ListaUser = ValueList(rsUsuarios.Usucodigo)>
<cfelse>
	<cfset ListaUser = '-1'>
</cfif>
<!--- centros de custodia que tengo acargo  --->
 <cfquery name="rsCCADmin" datasource="#Session.Dsn#">
 	Select b.CRCCid
		from UsuarioReferencia  a
			inner join CRCentroCustodia b
				on a.llave =  <cf_dbfunction name="to_char" args="b.DEid">
				and b.Ecodigo = #Session.Ecodigo#
	where STabla = 'DatosEmpleado'
	and a.Usucodigo   =  #session.Usucodigo# 
	and a.Ecodigo     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.ecodigosdc#">
 </cfquery>
<cfif rsCCADmin.recordcount gt 0>
	<cfset CCADmin = ValueList(rsCCADmin.CRCCid)>
<cfelse>
	<cfset CCADmin = '-1'>
</cfif>
 
<!--- centros de custodia en donde soy usuario --->
 <cfquery name="rsCCUSer" datasource="#Session.Dsn#">
	Select a.CRCCid  
		from CRCentroCustodia  a
		inner join CRCCUsuarios b 
			on b.CRCCid = a.CRCCid 
			and b.Usucodigo =  #session.Usucodigo# 
 </cfquery>

<cfif rsCCUSer.recordcount gt 0>
	<cfset CCUsuarios = ValueList(rsCCUSer.CRCCid)>
<cfelse>
	<cfset CCUsuarios = '-1'>
</cfif>


<cfquery name="rsCRTipoDocumento" datasource="#Session.Dsn#">
	select b.CRTDid as value,<cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo),' - ',rtrim(b.CRTDdescripcion)"> as description, 0, b.CRTDcodigo
		from CRTipoDocumento b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	union 
	select -1 as value, '--Todos--' as description, -1, ' ' 
		from dual
	order by 3,4
</cfquery>
<cfquery name="rsCRTipoCompra" datasource="#Session.Dsn#">
	select c.CRTCid as value, rtrim(c.CRTCcodigo) as description, 0, c.CRTCcodigo
		from CRTipoCompra c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	union 
	select -1 as value, '--Todos--' as description, -1, ' ' 
		from dual
	order by 3,4
</cfquery>
<!--- Consulta de Centro Funcional para el combo del filtro de la lista --->
<cfquery name="rsCFuncional" datasource="#Session.DSn#">
	select 	distinct cf.CFid as value, 
			rtrim(cf.CFcodigo) as description,
			0, 
			cf.CFcodigo
	from CRDocumentoResponsabilidad a
		inner join CFuncional cf 
			on cf.CFid = a.CFid
	where a.Ecodigo = #Session.Ecodigo# and CRDRestado = 5 
		and ( ( a.CRCCid  in (#CCUsuarios#) and a.BMUsucodigo  = #Session.Usucodigo#) 
		or ( a.CRCCid  in (#CCADmin#) and a.BMUsucodigo  in (#ListaUser#))) 	
	union 
	select 	-1 as value,'--Todos--' as description,-1,' ' 
	 from dual
	order by 3,4								
</cfquery>

<cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo) + ' - ' + rtrim(b.CRTDdescripcion)" returnvariable="CRTipoDocumento" delimiters="+" >
<cf_dbfunction name="concat" args="rtrim(DEidentificacion) + '-' + rtrim(d.DEapellido1) + ' ' + rtrim(d.DEapellido2) + ' ' + rtrim(d.DEnombre)" returnvariable="DatosEmpleado" delimiters="+" >
<cf_dbfunction name="concat" args="rtrim(f.CRCCcodigo) + ' - ' + rtrim(f.CRCCdescripcion)" returnvariable="CRCentroCustodia" delimiters="+" >

<cfinvoke 
	component="sif.Componentes.pListas" 
	method="pLista" 
	returnvariable="Lvar_Lista" 
	columnas="a.CRDRid, a.CRTCid, a.DEid, a.CFid,a.CRDRfdocumento, a.CRCCid, 
				#PreserveSingleQuotes(CRTipoDocumento)#  as CRTipoDocumento,
				#PreserveSingleQuotes(DatosEmpleado)#  as DatosEmpleado,
				rtrim(e.CFcodigo)  as CFuncional,
				#PreserveSingleQuotes(CRCentroCustodia)# as CRCentroCustodia,a.CRDRplaca,Usulogin"
	tabla="CRDocumentoResponsabilidad a 
				left outer join CRTipoDocumento b on 
					a.CRTDid = b.CRTDid
				left outer join DatosEmpleado d on
					a.DEid = d.DEid
				inner join  CFuncional e on
					a.CFid = e.CFid
				inner join  CRCentroCustodia f on
					a.CRCCid = f.CRCCid
				left outer join  CRCCUsuarios g on
					g.CRCCid  = a.CRCCid 
					and  g.Usucodigo = #Session.Usucodigo#	
				inner join Usuario u on
					a.BMUsucodigo = u.Usucodigo"
	filtro="a.Ecodigo=#Session.Ecodigo# and CRDRestado = 5 
				and ( ( a.CRCCid  in (#CCUsuarios#) and a.BMUsucodigo  = #Session.Usucodigo#) 
				or ( a.CRCCid  in (#CCADmin#) and a.BMUsucodigo  in (#ListaUser#))) 	
				order by a.CRDRid"
	desplegar="CRTipoDocumento,DatosEmpleado,CFuncional,CRDRplaca,Usulogin,CRDRfdocumento"
	etiquetas="Tipo de Documento, Empleado, Centro Funcional,Placa,Usuario,Fecha"
	filtrar_por="a.CRTDid,#PreserveSingleQuotes(DatosEmpleado)#,
					e.CFid,a.CRDRplaca,Usulogin,a.CRDRfdocumento"
	cortes="CRCentroCustodia"
	formatos="S,S,S,S,S,D"
	align="left,left,left,left,left,left"
	mostrar_filtro="true"
	filtrar_automatico="true"
	rscrtipodocumento="#rsCRTipoDocumento#"
	rsCFuncional="#rsCFuncional#"
	showemptylistmsg="true"
	emptylistmsg=" --- No se encontraron documentos de mejora --- "
	ira="#CurrentPage#"
	botones="Nuevo,Aplicar,Eliminar"
	checkboxes="S"
	keys="CRDRid"
	ajustar="N"
/>


<script language="javascript" type="text/javascript">
	function algunoMarcado()
	{
		var f = document.lista;
		if (f.chk) {			
			if (f.chk.value) {									
				if (f.chk.checked) { 
					return true;
				}					
			} 
			else {	
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) { 
						return true;
					}
				}
			}
		}
		return false;
	}
	
	function funcAplicar()
	{
		if (algunoMarcado()) {
			if (confirm("Desea procesar los elementos seleccionados?")){
				document.lista.action="mejoras-sql.cfm";
				return true;
			}
		} 
		else {
			alert("Debe seleccionar los elementos de la lista que desea procesar!");
		}
		return false;
	}
		
	function funcEliminar()
	{
		if (algunoMarcado()) {
			if (confirm("Desea eliminar los elementos seleccionados?")) {
				document.lista.action="mejoras-sql.cfm";
				document.lista.modo.value = 'Baja';
				return true;
			}
		}
		else {
			alert("Debe seleccionar los elementos de la lista que desea eliminar!");
		}
		return false;
	}
		
	document.lista.filtro_CRTipoDocumento.focus();
</script>
