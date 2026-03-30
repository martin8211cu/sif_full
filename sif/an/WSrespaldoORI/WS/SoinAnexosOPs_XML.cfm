<cfsetting enablecfoutputonly="yes">
<cfparam name="LvarANserver" 	default="">
<cfparam name="LvarANoperation" default="">
<cfparam name="LvarANwskey" 	default="">
<cfparam name="LvarANdetalle" 	default="">

<cfoutput>
<?xml version="1.0" encoding="iso-8859-1"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Author>Ing. &Oacute;scar Bonilla, MBA (Arikama Consultores S. A.)</Author>
  <Created>2005-11-01T15:03:22Z</Created>
  <LastSaved>2005-11-05T01:11:27Z</LastSaved>
  <Company>SOIN Soluciones Integrales</Company>
  <Version>1.0</Version>
 </DocumentProperties>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment/>
   <Borders/>
   <Font/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s24">
   <Borders/>
   <Font x:Family="Swiss" ss:Size="14" ss:Color="##0000FF" ss:Bold="1"/>
  </Style>
  <Style ss:ID="s25">
   <Borders/>
  </Style>
  <Style ss:ID="s26">
   <Borders/>
   <Font ss:Size="14" ss:Color="##0000FF"/>
  </Style>
  <Style ss:ID="s27">
   <Borders/>
   <Font ss:Size="12" ss:Color="##0000FF"/>
  </Style>
  <Style ss:ID="s28">
   <Borders/>
   <Font x:Family="Swiss" ss:Color="##FF0000" ss:Bold="1"/>
  </Style>
 </Styles>
 <Names>
  <NamedRange ss:Name="MSGERROR" ss:RefersTo="=SoinXLTI!R6C1"/>
 </Names>
 <Worksheet ss:Name="SoinXLTI">
  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="6" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s25">
   <Column ss:StyleID="s25" ss:AutoFitWidth="0" ss:Width="93"/>
   <Row ss:Hidden="1">
    <Cell><Data ss:Type="String">SoinXLTI</Data></Cell>
   </Row>
   <Row ss:Height="18">
    <Cell ss:StyleID="s24"><Data ss:Type="String">SOIN Soluciones Integrales S. A.</Data></Cell>
   </Row>
   <Row ss:Height="18">
    <Cell ss:StyleID="s26"><Data ss:Type="String">Sistema de Informaci&oacute;n Financiera</Data></Cell>
   </Row>
   <Row ss:Height="15">
    <Cell ss:StyleID="s27"><Data ss:Type="String">Generaci&oacute;n de Anexos Financieros en Excel</Data></Cell>
   </Row>
   <Row ss:Index="6">
    <Cell ss:StyleID="s28"><ss:Data ss:Type="String"
      xmlns="http://www.w3.org/TR/REC-html40"><B><Font html:Color="##FF0000">ERROR: </Font></B><Font
       html:Color="##FF0000">Esta hoja Requiere que est&eacute; instalado y est&eacute; activo el Add-ins/Complementos SOINanexos.xla en Microsoft Excel</Font></ss:Data><NamedCell
      ss:Name="MSGERROR"/></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Selected/>
   <DoNotDisplayGridlines/>
   <DoNotDisplayHeadings/>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="SoinXLOP">
  <Table ss:ExpandedColumnCount="12" ss:ExpandedRowCount="#LvarRows#" x:FullColumns="1"
   x:FullRows="1">
   <Column ss:Width="90.75"/>
   <Row>
    <Cell><Data ss:Type="String">SoinXLOP</Data></Cell>

    <?====================================?>
    <?INICIO de las operaciones de Calculo?>
    <?====================================?>

    <Cell><Data ss:Type="String">#LvarANserver#/cfmx/sif/an/WS/anexosWS.cfc?WSDL</Data></Cell>
   </Row>
   <Row>
    <Cell><Data ss:Type="String">#LvarANoperation#</Data></Cell>
    <Cell><Data ss:Type="String">#LvarANwskey#</Data></Cell>
   </Row>
#LvarANdetalle#
<!---
   <Row>
    <Cell><Data ss:Type="String">1500000000000095</Data></Cell>
    <Cell><Data ss:Type="String">ACKEY</Data></Cell>
    <Cell><Data ss:Type="String">S</Data></Cell>
    <Cell><Data ss:Type="String">ANoscar</Data></Cell>
   </Row>
--->
    <?===================================?>
    <?FINAL de las operaciones de Calculo?>
    <?===================================?>

   <Row>
    <Cell><Data ss:Type="String">EOF</Data></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Visible>SheetVeryHidden</Visible>
  </WorksheetOptions>
 </Worksheet>
</Workbook>
</cfoutput>

