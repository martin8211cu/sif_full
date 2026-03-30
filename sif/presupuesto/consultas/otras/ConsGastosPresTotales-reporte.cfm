<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
  <style type="text/css">
    a {text-decoration: none}
  </style>
</head>
<body text="#000000" link="#000000" alink="#000000" vlink="#000000">

<cfset CtaIni = trim(form.CMayor) & "-"& trim(form.CFnivel1) & "-"& trim(form.CFnivel2) & "-"& trim(form.CFnivel3)>
<cfset CtaFin = trim(form.CMayor) & "-"& trim(form.CFnivel21) & "-"& trim(form.CFnivel22) & "-"& trim(form.CFnivel23)>

<cfquery name="rsPresupuesto" datasource="#Session.DSN#">
select cpc.CPCano as Periodo, 
	cpc.CPCmes as Mes, 
	cp.CPformato as Cuenta, 
	coalesce(cp.CPdescripcionF,cp.CPdescripcion) as Descripcion_Cuenta , 
	cpc.CPCpresupuestado + cpc.CPCmodificado + cpc.CPCvariacion + cpc.CPCtrasladado + cpc.CPCtrasladadoE as PresupuestoAutorizado , 
	cpc.CPCvariacion, 
	cpc.CPCmodificado, 
	(cpc.CPCejecutado + cpc.CPCejecutadoNC) as CPCejecutado, 
	(cpc.CPCpresupuestado + cpc.CPCmodificado + cpc.CPCvariacion + cpc.CPCtrasladado + cpc.CPCtrasladadoE) - (cpc.CPCejecutado + cpc.CPCejecutadoNC) as Diferencia,
	 (select sum(cpc1.CPCpresupuestado + cpc1.CPCmodificado + cpc1.CPCvariacion + cpc1.CPCtrasladado + cpc1.CPCtrasladadoE) 
				from  CPresupuestoControl cpc1 , CPresupuestoPeriodo cpp
				where cpc1.Ecodigo = #session.ecodigo#
				  and cpc1.Ecodigo = cpp.Ecodigo 
				  and cpc1.CPPid = cpp.CPPid
				and (cpc1.CPCano < cpc.CPCano
				   OR cpc1.CPCano = cpc.CPCano
				   and cpc1.CPCmes <= cpc.CPCmes)
				and cpc1.CPcuenta = cpc.CPcuenta
				and cpc1.Ocodigo = cpc.Ocodigo 
 				group by cpc1.CPcuenta
 ) as PresupuestoAutorizadoAcum,
 (select  sum(cpc1.CPCejecutado + cpc1.CPCejecutadoNC)
				from  CPresupuestoControl cpc1 , CPresupuestoPeriodo cpp
				where cpc1.Ecodigo = #session.ecodigo#
				  and cpc1.Ecodigo = cpp.Ecodigo 
				  and cpc1.CPPid = cpp.CPPid
				and (cpc1.CPCano < cpc.CPCano
				   OR cpc1.CPCano = cpc.CPCano
				   and cpc1.CPCmes <= cpc.CPCmes)
				and cpc1.CPcuenta = cpc.CPcuenta
				and cpc1.Ocodigo = cpc.Ocodigo 
 				group by cpc1.CPcuenta
 ) as PresupuestoEjecutadoAcum,
e.Edescripcion as Edescripcion,
(select  sum((cpc1.CPCpresupuestado + cpc1.CPCmodificado + cpc1.CPCvariacion + cpc1.CPCtrasladado + cpc1.CPCtrasladadoE) - (cpc1.CPCejecutado + cpc1.CPCejecutadoNC))
				from  CPresupuestoControl cpc1 , CPresupuestoPeriodo cpp
				where cpc1.Ecodigo = #session.ecodigo#
				  and cpc1.Ecodigo = cpp.Ecodigo 
				  and cpc1.CPPid = cpp.CPPid
				and (cpc1.CPCano < cpc.CPCano
				   OR cpc1.CPCano = cpc.CPCano
				   and cpc1.CPCmes <= cpc.CPCmes)
				and cpc1.CPcuenta = cpc.CPcuenta
				and cpc1.Ocodigo = cpc.Ocodigo 
 				group by cpc1.CPcuenta
 ) as DiferenciaAcum,
  cp1.CPformato as CuentaPadre,
  coalesce(cp1.CPdescripcionF,cp1.CPdescripcion) as DescCuentaPadre,
(select m.Mnombre from Monedas m, CPresupuestoPeriodo cpp2
	where m.Ecodigo = cpp2.Ecodigo
 	    and  m.Mcodigo = cpp2.Mcodigo
     	    and cpp2.Ecodigo = cpc.Ecodigo
	    and cpp2.CPPid = cpc.CPPid
) as NombMoneda
from CPresupuesto cp
	left outer join CPresupuesto cp1
  	  on cp.Ecodigo = cp1.Ecodigo
	  and cp.CPpadre = cp1.CPcuenta
 	inner join CPresupuestoControl cpc
	  on cpc.Ecodigo = #Session.Ecodigo#
	  and cpc.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPCano#">
	  and cpc.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPCmes#">
	  <cfif isdefined("form.Oficina") and len(trim(form.Oficina)) neq 0>
	  	and cpc.Ocodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Oficina#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Oficina#">
	  </cfif>
	  and cpc.Ecodigo = cp.Ecodigo
	  and cpc.CPcuenta = cp.CPcuenta
	inner join Empresas e
	  on  cp.Ecodigo = e.Ecodigo
where cp.CPformato between <cfqueryparam cfsqltype="cf_sql_char" value="#CtaIni#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#CtaFin#">
order by cp1.CPformato
</cfquery>

<cfif isdefined("form.Oficina") and len(trim(form.Oficina)) neq 0>
	<cfquery name="rsOficinas" datasource="minisif">
		select Ocodigo, Odescripcion 
		from Oficinas 
		where Ecodigo = #session.ecodigo#
		and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Oficina#"> 
	</cfquery>
</cfif>
<cfquery name="meses" datasource="minisif">
	select distinct CPCmes, case when CPCmes = 1 then 'Enero' 
								 when CPCmes = 2 then 'Febrero' 
								 when CPCmes = 3 then 'Marzo' 
								 when CPCmes = 4 then 'Abril' 
								 when CPCmes = 5 then 'Mayo' 
								 when CPCmes = 6 then 'Junio' 
								 when CPCmes = 7 then 'Julio' 
								 when CPCmes = 8 then 'Agosto' 
								 when CPCmes = 9 then 'Septiembre' 
								 when CPCmes = 10 then 'Octubre' 
								 when CPCmes = 11 then 'Noviembre' 
								when CPCmes = 12 then 'Diciembre' 
							end as mes
	from CPresupuestoControl
	where Ecodigo = #session.ecodigo#
	   and CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPCmes#">
	order by CPCmes
</cfquery>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr><td width="50%">&nbsp;</td><td align="center">

<a name="JR_PAGE_ANCHOR_1">
<table width=793 cellpadding=0 cellspacing=0 border=0
 bgcolor=white>
<tr>
  <td><img src="image.jsp?i=px" width=31 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=65 height=1></td>
  <td><img src="image.jsp?i=px" width=9 height=1></td>
  <td><img src="image.jsp?i=px" width=15 height=1></td>
  <td><img src="image.jsp?i=px" width=3 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=49 height=1></td>
  <td><img src="image.jsp?i=px" width=12 height=1></td>
  <td><img src="image.jsp?i=px" width=46 height=1></td>
  <td><img src="image.jsp?i=px" width=14 height=1></td>
  <td><img src="image.jsp?i=px" width=3 height=1></td>
  <td><img src="image.jsp?i=px" width=4 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=11 height=1></td>
  <td><img src="image.jsp?i=px" width=25 height=1></td>
  <td><img src="image.jsp?i=px" width=21 height=1></td>
  <td><img src="image.jsp?i=px" width=4 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=3 height=1></td>
  <td><img src="image.jsp?i=px" width=6 height=1></td>
  <td><img src="image.jsp?i=px" width=50 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=14 height=1></td>
  <td><img src="image.jsp?i=px" width=9 height=1></td>
  <td><img src="image.jsp?i=px" width=32 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=3 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=38 height=1></td>
  <td><img src="image.jsp?i=px" width=7 height=1></td>
  <td><img src="image.jsp?i=px" width=12 height=1></td>
  <td><img src="image.jsp?i=px" width=4 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=4 height=1></td>
  <td><img src="image.jsp?i=px" width=26 height=1></td>
  <td><img src="image.jsp?i=px" width=30 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=56 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=3 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=76 height=1></td>
  <td><img src="image.jsp?i=px" width=31 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=2 height=1></td>
  <td><img src="image.jsp?i=px" width=1 height=1></td>
  <td><img src="image.jsp?i=px" width=33 height=1></td>
</tr>
<tr valign=top>
  <td colspan=69><img src="image.jsp?i=px" width=793 height=37></td>
</tr>
<tr valign=top>
  <td colspan=4><img src="image.jsp?i=px" width=34 height=1></td>
  <td colspan=60 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
  <td colspan=5><img src="image.jsp?i=px" width=38 height=1></td>
</tr>
<tr valign=top>
  <td colspan=69><img src="image.jsp?i=px" width=793 height=2></td>
</tr>
<tr valign=top>
  <td colspan=6><img src="image.jsp?i=px" width=36 height=0></td> 
  <td colspan=60 valign="middle" style="text-align: center;"><font face="SansSerif" style="font-size: 22px; text-align: center;"><b><cfoutput>#Session.CEnombre#</cfoutput></b></font></td>
  <td colspan=3><img src="image.jsp?i=px" width=36 height=28></td>
</tr>
<tr valign=top>
  <td colspan=69><img src="image.jsp?i=px" width=793 height=6></td>
</tr>
<tr valign=top>
  <td colspan=7><img src="image.jsp?i=px" width=38 height=19></td>
  <td colspan=58 style="text-align: center;"><font face="SansSerif" style="font-size: 14px; text-align: center;"><b>Gastos del Presupuesto - Totales </b></font></td>
  <td colspan=4><img src="image.jsp?i=px" width=37 height=19></td>
</tr>
<tr valign=top>
  <td colspan=7><img src="image.jsp?i=px" width=38 height=19></td>
  <td colspan=58 style="text-align: center;"><font face="SansSerif" style="font-size: 14px; text-align: center;"><b>Desde: &nbsp;&nbsp;  &nbsp;&nbsp;<cfoutput>#CtaIni#</cfoutput> &nbsp;&nbsp; &nbsp;&nbsp; hasta:  &nbsp;&nbsp;&nbsp;&nbsp;<cfoutput>#CtaFin#</cfoutput></b></font></td>
  <td colspan=4><img src="image.jsp?i=px" width=37 height=19></td>
</tr>
<tr valign=top>
  <td colspan=69><img src="image.jsp?i=px" width=793 height=6></td>
</tr>
<tr valign=top>
  <td colspan=9><img src="image.jsp?i=px" width=112 height=16></td>
  <td colspan=6><font face="SansSerif" style="font-size: 12px;"><b>Del Periodo:</b></font></td>
  <td><img src="image.jsp?i=px" width=12 height=16></td>
  <td colspan=7><font face="SansSerif" style="font-size: 12px;"><cfoutput>#form.CPCano#</cfoutput></font></td>
  <td colspan=2><img src="image.jsp?i=px" width=12 height=16></td>
  <td colspan=5><font face="SansSerif" style="font-size: 12px;"><b>Del Mes:</b></font></td>
  <td colspan=2><img src="image.jsp?i=px" width=9 height=16></td>
  <td colspan=6><font face="SansSerif" style="font-size: 12px;"><cfoutput>#meses.mes#</cfoutput></font></td>
  <td><img src="image.jsp?i=px" width=9 height=16></td>
  <td colspan=8><font face="SansSerif" style="font-size: 12px;"><b>De la Oficina:</b></font></td>
  <td><img src="image.jsp?i=px" width=7 height=16></td>
  <td colspan=14  align="center">
		<font face="SansSerif" style="font-size: 12px;">
			<cfif isdefined("rsOficinas")>
				  <cfoutput>#rsOficinas.Odescripcion#</cfoutput>
			<cfelse>
				Todas
			</cfif>
		</font>
  
  </td>
  <td colspan=7><img src="image.jsp?i=px" width=145 height=16></td>
</tr>

<tr valign=top>
  <td colspan=69><img src="image.jsp?i=px" width=793 height=7></td>
</tr>

	<tr valign=top>
	  <td colspan=4><img src="image.jsp?i=px" width=34 height=1></td>
	  <td colspan=60 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
	  <td colspan=5><img src="image.jsp?i=px" width=38 height=1></td>
	</tr>
	<tr valign=top>
	  <td colspan=69><img src="image.jsp?i=px" width=793 height=8></td>
	</tr>
<cfif rsPresupuesto.RecordCount GT 0>
	<tr valign=top>
	  <td colspan=20><img src="image.jsp?i=px" width=261 height=1></td>
	  <td colspan=47 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
	  <td colspan=2><img src="image.jsp?i=px" width=34 height=1></td>
	</tr>
	<tr valign=top>
	  <td colspan=20><img src="image.jsp?i=px" width=261 height=3></td>
	  <td rowspan=3 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
	  <td colspan=22><img src="image.jsp?i=px" width=191 height=3></td>
	  <td rowspan=3 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
	  <td colspan=16><img src="image.jsp?i=px" width=192 height=3></td>
	  <td rowspan=3 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
	  <td colspan=6><img src="image.jsp?i=px" width=112 height=3></td>
	  <td rowspan=3 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
	  <td><img src="image.jsp?i=px" width=33 height=3></td>
	</tr>
</cfif>
<cfset moneda = "">
<cfset LblcuentaPadre = "">
<cfloop query="rsPresupuesto">	
	
	<cfif rsPresupuesto.NombMoneda NEQ moneda>
		<tr valign=top>
		  <td colspan=5><img src="image.jsp?i=px" width=35 height=21></td>
		  <td colspan=3 style="text-align: center;"><font face="SansSerif" style="font-size: 12px; text-align: center;"><b>MONEDA:</b></font></td>
		  <td><img src="image.jsp?i=px" width=9 height=21></td>
		  <td colspan=9><font face="SansSerif" style="font-size: 12px;"><b><cfoutput>#rsPresupuesto.NombMoneda#</cfoutput></b></font></td>
		  <td colspan=2><img src="image.jsp?i=px" width=7 height=21></td>
		  <td colspan=3><img src="image.jsp?i=px" width=3 height=21></td>
		  <td colspan=16 style="text-align: center;"><font face="SansSerif" style="font-size: 12px; text-align: center;"><b>MENSUAL</b></font></td>
		  <td colspan=3><img src="image.jsp?i=px" width=5 height=21></td>
		  <td colspan=2><img src="image.jsp?i=px" width=4 height=21></td>
		  <td colspan=12 style="text-align: center;"><font face="SansSerif" style="font-size: 12px; text-align: center;"><b>ACUMULADO</b></font></td>
		  <td colspan=2><img src="image.jsp?i=px" width=5 height=21></td>
		  <td colspan=6><img src="image.jsp?i=px" width=112 height=21></td>
		  <td><img src="image.jsp?i=px" width=33 height=21></td>
		</tr>
		<tr valign=top>
		  <td colspan=20><img src="image.jsp?i=px" width=261 height=3></td>
		  <td colspan=22><img src="image.jsp?i=px" width=191 height=3></td>
		  <td colspan=16><img src="image.jsp?i=px" width=192 height=3></td>
		  <td colspan=6><img src="image.jsp?i=px" width=112 height=3></td>
		  <td><img src="image.jsp?i=px" width=33 height=3></td>
		</tr>
		<tr valign=top>
		  <td colspan=4><img src="image.jsp?i=px" width=34 height=1></td>
		  <td colspan=60 bgcolor=#000000><img src="image.jsp?i=px" border=0 width=800 height=1></td>
		  <td colspan=5><img src="image.jsp?i=px" width=38 height=1></td>
		</tr>
		<tr valign=top>
		  <td colspan=69><img src="image.jsp?i=px" width=793 height=2></td>
		</tr>
		
		<tr valign=top>
		  <td colspan=2><img src="image.jsp?i=px" width=32 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=8><img src="image.jsp?i=px" width=97 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=8><img src="image.jsp?i=px" width=130 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=7><img src="image.jsp?i=px" width=64 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=5><img src="image.jsp?i=px" width=62 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=8><img src="image.jsp?i=px" width=63 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=6><img src="image.jsp?i=px" width=65 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=4><img src="image.jsp?i=px" width=62 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=4><img src="image.jsp?i=px" width=63 height=1></td>
		  <td rowspan=4 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=6><img src="image.jsp?i=px" width=112 height=1></td>
		  <td rowspan=5 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td><img src="image.jsp?i=px" width=33 height=1></td>
		</tr>
		<tr valign=top>
		  <td colspan=2><img src="image.jsp?i=px" width=32 height=1></td>
		  <td colspan=8><img src="image.jsp?i=px" width=97 height=1></td>
		  <td colspan=8><img src="image.jsp?i=px" width=130 height=1></td>
		  <td colspan=7><img src="image.jsp?i=px" width=64 height=1></td>
		  <td colspan=5><img src="image.jsp?i=px" width=62 height=1></td>
		  <td colspan=8><img src="image.jsp?i=px" width=63 height=1></td>
		  <td colspan=6><img src="image.jsp?i=px" width=65 height=1></td>
		  <td colspan=4><img src="image.jsp?i=px" width=62 height=1></td>
		  <td colspan=4><img src="image.jsp?i=px" width=63 height=1></td>
		  <td colspan=6><img src="image.jsp?i=px" width=112 height=1></td>
		  <td><img src="image.jsp?i=px" width=33 height=1></td>
		</tr>
		
	
		
		<tr valign=top>
		  <td colspan=2><img src="image.jsp?i=px" width=32 height=19></td>
		  <td colspan=2><img src="image.jsp?i=px" width=2 height=19></td>
		  <td colspan=5 style="text-align: center;"><font face="SansSerif" style="font-size: 10px; text-align: center;"><b>Cuenta Contable</b></font></td>
		  <td><img src="image.jsp?i=px" width=3 height=19></td>
		  <td colspan=2><img src="image.jsp?i=px" width=2 height=19></td>
		  <td colspan=5 style="text-align: center;"><font face="SansSerif" style="font-size: 10px; text-align: center;"><b>Descripci&oacute;n</b></font></td>
		  <td><img src="image.jsp?i=px" width=4 height=19></td>
		  <td colspan=2><img src="image.jsp?i=px" width=2 height=19></td>
		  <td colspan=4 style="text-align: center;"><font face="SansSerif" style="font-size: 10px; text-align: center;"><b>Real</b></font></td>
		  <td><img src="image.jsp?i=px" width=4 height=19></td>
		  <td colspan=2><img src="image.jsp?i=px" width=4 height=19></td>
		  <td colspan=2 style="text-align: center;"><font face="SansSerif" style="font-size: 10px; text-align: center;"><b>Presup.</b></font></td>
		  <td><img src="image.jsp?i=px" width=2 height=19></td>
		  <td><img src="image.jsp?i=px" width=2 height=19></td>
		  <td colspan=5 style="text-align: center;"><font face="SansSerif" style="font-size: 10px; text-align: center;"><b>Diferencia</b></font></td>
		  <td colspan=2><img src="image.jsp?i=px" width=3 height=19></td>
		  <td><img src="image.jsp?i=px" width=3 height=19></td>
		  <td colspan=4 style="text-align: center;"><font face="SansSerif" style="font-size: 10px; text-align: center;"><b>Real</b></font></td>
		  <td><img src="image.jsp?i=px" width=4 height=19></td>
		  <td><img src="image.jsp?i=px" width=4 height=19></td>
		  <td colspan=2 style="text-align: center;"><font face="SansSerif" style="font-size: 10px; text-align: center;"><b>Presup.</b></font></td>
		  <td><img src="image.jsp?i=px" width=2 height=19></td>
		  <td><img src="image.jsp?i=px" width=2 height=19></td>
		  <td colspan=2 style="text-align: center;"><font face="SansSerif" style="font-size: 10px; text-align: center;"><b>Diferencia</b></font></td>
		  <td><img src="image.jsp?i=px" width=3 height=19></td>
		  <td colspan=6><img src="image.jsp?i=px" width=112 height=19></td>
		  <td><img src="image.jsp?i=px" width=33 height=19></td>
		</tr>
		<tr valign=top>
		  <td colspan=2><img src="image.jsp?i=px" width=32 height=2></td>
		  <td colspan=8><img src="image.jsp?i=px" width=97 height=2></td>
		  <td colspan=8><img src="image.jsp?i=px" width=130 height=2></td>
		  <td colspan=7><img src="image.jsp?i=px" width=64 height=2></td>
		  <td colspan=5><img src="image.jsp?i=px" width=62 height=2></td>
		  <td colspan=8><img src="image.jsp?i=px" width=63 height=2></td>
		  <td colspan=6><img src="image.jsp?i=px" width=65 height=2></td>
		  <td colspan=4><img src="image.jsp?i=px" width=62 height=2></td>
		  <td colspan=4><img src="image.jsp?i=px" width=63 height=2></td>
		  <td colspan=6><img src="image.jsp?i=px" width=112 height=2></td>
		  <td><img src="image.jsp?i=px" width=33 height=2></td>
		</tr>
		<tr valign=top>
		  <td colspan=67><img src="image.jsp?i=px" width=759 height=1></td>
		  <td><img src="image.jsp?i=px" width=33 height=1></td>
		</tr>
		<tr valign=top>
		  <td colspan=4><img src="image.jsp?i=px" width=34 height=1></td>
		  <td colspan=63 bgcolor=#000000><img src="image.jsp?i=px" border=0></td>
		  <td colspan=2><img src="image.jsp?i=px" width=34 height=1></td>
		</tr>
		<tr valign=top>
		  <td colspan=69><img src="image.jsp?i=px" width=793 height=2></td>
		</tr>
		<cfset moneda = rsPresupuesto.NombMoneda >
</cfif>
	<cfif LblcuentaPadre NEQ rsPresupuesto.CuentaPadre>
		<cfset LblcuentaPadre = trim(rsPresupuesto.CuentaPadre)>
		<tr valign=top>
		  <td colspan=5><img src="image.jsp?i=px" width=35 height=12></td>
		  <td colspan=7><font face="SansSerif" style="font-size: 10px;"><b><cfoutput>#rsPresupuesto.CuentaPadre#</cfoutput></b></font></td>
		  <td><img src="image.jsp?i=px" width=1 height=12></td>
		  <td colspan=13><font face="SansSerif" style="font-size: 10px; text-decoration: underline;"><b><cfoutput>#rsPresupuesto.DescCuentaPadre#</cfoutput></b></font></td>
		  <td colspan=43><img src="image.jsp?i=px" width=492 height=12></td>
		</tr>
		<tr valign=top>
		  <td colspan=69><img src="image.jsp?i=px" width=793 height=2></td>
		</tr>
	</cfif>
	<cfoutput>
		<tr valign=top>
		  <td colspan=5><img src="image.jsp?i=px" width=35 height=12></td>
		  <td colspan=7><font face="SansSerif" style="font-size: 10px;">#rsPresupuesto.Cuenta#                                                                            </font></td>
		  <td><img src="image.jsp?i=px" width=1 height=12></td>
		  <td colspan=9><font face="SansSerif" style="font-size: 10px;">#rsPresupuesto.Descripcion_Cuenta#</font></td>
		  <td><img src="image.jsp?i=px" width=1 height=12></td>
		  <td colspan=4 style="text-align: right;"><font face="SansSerif" style="font-size: 10px; text-align: right;">#LSNumberFormat(rsPresupuesto.CPCejecutado,',9.00')#</font></td>
		  <td colspan=4><img src="image.jsp?i=px" width=9 height=12></td>
		  <td colspan=3 style="text-align: right;"><font face="SansSerif" style="font-size: 10px; text-align: right;">#LSNumberFormat(rsPresupuesto.PresupuestoAutorizado,',9.00')#</font></td>
		  <td colspan=3><img src="image.jsp?i=px" width=4 height=12></td>
		  <td colspan=5 style="text-align: right;"><font face="SansSerif" style="font-size: 10px; text-align: right;">#LSNumberFormat(rsPresupuesto.Diferencia,',9.00')#</font></td>
		  <td colspan=3><img src="image.jsp?i=px" width=6 height=12></td>
		  <td colspan=4 style="text-align: right;"><font face="SansSerif" style="font-size: 10px; text-align: right;">#LSNumberFormat(rsPresupuesto.PresupuestoEjecutadoAcum,',9.00')#</font></td>
		  <td colspan=3><img src="image.jsp?i=px" width=9 height=12></td>
		  <td colspan=3 style="text-align: right;"><font face="SansSerif" style="font-size: 10px; text-align: right;">#LSNumberFormat(rsPresupuesto.PresupuestoAutorizadoAcum,',9.00')#</font></td>
		  <td colspan=2><img src="image.jsp?i=px" width=3 height=12></td>
		  <td colspan=2 style="text-align: right;"><font face="SansSerif" style="font-size: 10px; text-align: right;">#LSNumberFormat(rsPresupuesto.DiferenciaAcum,',9.00')#</font></td>
		  <td colspan=10><img src="image.jsp?i=px" width=150 height=12></td>
		</tr>
		<tr valign=top>
		  <td colspan=69><img src="image.jsp?i=px" width=793 height=2></td>
		</tr>
	</cfoutput>
</cfloop>
<cfif rsPresupuesto.RecordCount GT 0>
	<tr><td colspan="69" nowrap>&nbsp;</td></tr>
	<tr><td colspan="69" nowrap align="center" >---------- Fin de la Consulta ----------</td></tr>
<cfelse>
	<tr><td colspan="69" nowrap>&nbsp;</td></tr>
	<tr><td colspan="69" nowrap align="center" class="listaCorte"><strong>--- La Consulta no Gener&oacute; Resultados ---</strong></td></tr>
</cfif>

<tr valign=top>
  <td><img src="image.jsp?i=px" width=31 height=19></td>
  <td colspan=16><font face="Times-Roman" style="font-size: 10px;"><cfoutput>#LSDateFormat(now(),"dd/MM/yyyy")#</cfoutput></font></td>
  <td colspan=36><img src="image.jsp?i=px" width=310 height=19></td>
  <td colspan=10 style="text-align: right;">&nbsp;</td>
  <td colspan=5><font face="Helvetica" style="font-size: 10px;">1</font></td>
  <td><img src="image.jsp?i=px" width=33 height=19></td>
</tr>
<tr valign=top>
  <td colspan=69><img src="image.jsp?i=px" width=793 height=23></td>
</tr>
</table>
<br style='page-break-after:always'>
</td><td width="50%">&nbsp;</td></tr>
</table>

</body>
</html>

