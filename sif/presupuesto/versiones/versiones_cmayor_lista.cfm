<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="qry_lista" datasource="#session.dsn#">
		select a.CVid, a.Cmayor, b.Cdescripcion, 
	 (case CVMtipoControl when 0 then 'Abierto' when 1 then 'Restringido' when 2 then 'Restrictivo' end) as CVMtipoControl,
	 (case CVMcalculoControl when 1 then 'Mensual' when 2 then 'Acumulado' when 3 then 'Total' end) as CVMcalculoControl,
	 case 
	 	when coalesce(a.Cmascara,' ') <> ' ' 
		then 
			case
				when exists
					(
						select 1 from CVPresupuesto cc
						  where cc.Ecodigo	= a.Ecodigo
						    and cc.CVid		= a.CVid
							and cc.Cmayor	= a.Cmayor
					) then
						'<a href=''javascript:funccpresup(' #_Cat# <cf_dbfunction name="to_char" args="a.CVid"> #_Cat# ',&quot;' #_Cat# a.Cmayor #_Cat# '&quot;);''><img src=''/cfmx/sif/imagenes/Base.gif'' border=''0''><img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''></a>' 
					else
						'<a href=''javascript:funccpresup(' #_Cat# <cf_dbfunction name="to_char" args="a.CVid"> #_Cat# ',&quot;' #_Cat# a.Cmayor #_Cat# '&quot;);''><img src=''/cfmx/sif/imagenes/Base.gif'' border=''0''><img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''></a>' 
					end
	 end as cpresupimglink,  
	 <cfif session.versiones.formular EQ "V">0<cfelse>1</cfif> as cpresup
	from CVMayor a 
		inner join CtasMayor b
			on b.Cmayor = a.Cmayor
			and b.Ecodigo = a.Ecodigo
	where a.Ecodigo = #Session.Ecodigo#
	and a.CVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CVid#">
	<cfif isdefined("form.chkSoloPresupuesto")>
	and coalesce(a.Cmascara,' ') <> ' '
	</cfif>
	order by a.Ecodigo, a.CVid, a.Cmayor	
</cfquery>
<cfset navegacion = "&CVid=#form.CVid#">

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
 	<cfinvokeargument name="query" value="#qry_lista#">
	<cfinvokeargument name="desplegar" value="Cmayor, Cdescripcion, CVMtipoControl, CVMcalculoControl, cpresupimglink"/>
	<cfinvokeargument name="etiquetas" value="Mayor, Descripción, Tipo<BR>Control, Cálculo<BR>Control, Formular"/>
	<cfinvokeargument name="formatos" value="S, S, S, S, S"/>
	<cfinvokeargument name="align" value="left, left, left, left, center"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="/cfmx/sif/presupuesto/versiones/versionesComun.cfm"/>
	<cfinvokeargument name="keys" value="CVid, Cmayor"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="pageindex" value="2"/>
	<cfinvokeargument name="formname" value="lista2"/>
	<cfinvokeargument name="maxrows" value="10"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
<script language="javascript" type="text/javascript">
	<!--//
		function funccpresup(cvid,cmayor){
			/*document.lista2.CVID.value=cvid;
			document.lista2.CMAYOR.value=cmayor;
			document.lista2.CPRESUP.value=1;
			document.lista2.submit();
			*/
			location.href="/cfmx/sif/presupuesto/versiones/versionesComun.cfm?cvid="+cvid+"&cmayor="+cmayor+"&cpresup=1";
		}
	//-->
</script>
