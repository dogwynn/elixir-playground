def fqdn(raw, labels=None, buf=None, rest=None):
    if labels is None:
        return fqdn(raw[12:], (), raw[12:])

    if buf[0] == 0:
        return labels, rest or buf[1:]

    if buf[0] == 192:
        ref = buf[1]
        print('new ref:', ref)
        return fqdn(raw, labels, raw[ref:], rest or buf[2:])

    new_size = buf[0]
    print('new size:', new_size)
    return fqdn(
        raw,
        labels + (buf[1: 1 + new_size], ),
        buf[1 + new_size:],
        rest,
    )

def fqdn(data, labels, buf):
    if buf[0] == 0:
        return labels

    if buf[0] == 192:
        ref = buf[1]
        return fqdn(data, labels, data[ref:])

    size = buf[0]
    return fqdn(
        data, labels + (buf[1: 1 + size],), buf[1 + size:]
    )

def get_rest(buf):
    if buf[0] == 0:
        return buf[1:]
    if buf[0] == 192:
        return buf[2:]
    size = buf[0]
    return get_rest(buf[1 + size:])
