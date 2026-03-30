<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.debug = true>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<strong>EJECUTANDO LA FUNCION NuevoAsiento</strong><br>
<cfset timeinit = Now()>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
<cfinvoke 
 component="sif.Componentes.Contabilidad"
 method="Nuevo_Asiento"
 returnvariable="Nuevo_AsientoRet">
	<cfinvokeargument name="Oorigen" value="AFRT"/>
	<cfinvokeargument name="Eperiodo" value="1"/>
	<cfinvokeargument name="Emes" value="1"/>
	<cfinvokeargument name="debug" value="1"/>
</cfinvoke>
<cfset timefin = Now()>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>

<strong>RETORNA:&nbsp;<cfoutput>#Nuevo_AsientoRet#</cfoutput></strong><br>

<strong>TEXTO DEL SP</strong><br>

<table width="100%"  border="1" cellspacing="1" cellpadding="1">
  <tr>
    <td>
		
if exists (select 1<br>
from sysobjects<br>
where id = object_id('CG_NuevoAsiento')<br>
and type = 'P')<br>
drop procedure CG_NuevoAsiento<br>
go
<p>&nbsp;</p>
<p>create procedure CG_NuevoAsiento<br>
  @Ecodigo int,<br>
  @Cconcepto int,<br>
  @Oorigen char(4),<br>
  @Eperiodo int,<br>
  @Emes int,<br>
  @Edocumento int output,<br>
  @hacerselect bit = 0<br>
  as<br>
  begin</p>
<p>&lt;!---1---&gt;</p>
<p>if @Cconcepto is null begin<br>
  select @Cconcepto = Cconcepto<br>
  from ConceptoContable<br>
  where Ecodigo = @Ecodigo<br>
  and Oorigen = @Oorigen<br>end</p>
<p>&lt;!---2---&gt; </p>
<p>if @Cconcepto is null<br>
  begin<br>
  raiserror 40000 &quot;Error!, No se ha definido el concepto de asiento contable&quot;<br>
  return -1<br>
  end</p>
<p>&lt;!---3---&gt; </p>
<p> update ConceptoContableN<br>
  set Edocumento = Edocumento + 1<br>
  where Ecodigo = @Ecodigo<br>
  and Cconcepto = @Cconcepto<br>
  and Eperiodo = @Eperiodo<br>
  and Emes = @Emes</p>
<p>&lt;!---4---&gt; </p>
<p> if @@rowcount = 0 begin<br>
  insert ConceptoContableN (Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento)<br>
  select @Ecodigo, @Cconcepto, @Eperiodo, @Emes, 1<br>
  if @@error != 0 begin<br>
  raiserror 40000 'Error, No se pudo insertar el Concepto Contable! (Tabla: ConceptoContableN) Proceso Cancelado!'<br>
  return -1<br>
  end</p>
<p> end</p>
<p>&lt;!---5---&gt; </p>
<p>select @Edocumento = Edocumento<br>
    from ConceptoContableN<br>
    where Ecodigo = @Ecodigo<br>
    and Cconcepto = @Cconcepto<br>
    and Eperiodo = @Eperiodo<br>
    and Emes = @Emes</p>
<p>&lt;!---6---&gt; </p>
<p>if @hacerselect = 1<br>
  select @Edocumento as documento</p>
<p>end<br>
  go<br>
  sp_procxmode CG_NuevoAsiento , anymode<br>
  go<br>
</p>
</td>
  </tr>
</table>
</body>
</html>
