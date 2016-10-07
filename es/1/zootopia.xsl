<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
<xsl:template match="/">
  <html>
    <head>
      <link rel="stylesheet" href="zootopia.css" />
    </head>
  <body>
  <h2>My zootopia</h2>
  <table border="1">
    <tr>
      <th>ID</th>
      <th>Type</th>
      <th>Skin</th>
      <th>Noise</th>
      <th>Eyes</th> 
    </tr>
    <xsl:for-each select="zootopia/animal">
    <tr>
      <td class='id-theme'><xsl:value-of select="@id"/></td>
      <td class='name-theme'><xsl:value-of select="type"/></td>
      <td class='skin-theme'><xsl:value-of select="skin/colortype"/>, <xsl:value-of select="skin/palette"/></td>
      <td class='noise-theme'>"<xsl:value-of select="noise/voice"/>", <xsl:value-of select="noise/loudness"/>, <xsl:value-of select="noise/range"/></td>
      <td class='eye-theme'><xsl:value-of select="eyes/size"/>, <xsl:value-of select="eyes/form"/></td> 
    </tr>
    </xsl:for-each>
  </table>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet> 