Document Sample {

  # Add an introduction section
  Section Introduction {
      # Add a comment
      "This is a sample file list from $TargetObject"

      # Generate a table
      Get-ChildItem -Path $TargetObject | Table -Property Name,PSIsContainer
  }
}
