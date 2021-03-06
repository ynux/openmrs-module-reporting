package org.openmrs.module.reporting.data.converter;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.calculation.ConversionException;

public class MostRecentlyCreatedConverterTest {
    /**
     * @verifies throw conversion exception when class cast fails
     * @see MostRecentlyCreatedConverter#convert(Object)
     */
    @Test(expected = ConversionException.class)
    public void convert_shouldThrowConversionExceptionWhenClassCastFails() throws Exception {
        MostRecentlyCreatedConverter converter = new MostRecentlyCreatedConverter(null);
        converter.convert("invalid input");
    }
}
